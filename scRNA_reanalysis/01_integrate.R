# ============================================================
# 01 - 读取 / QC / 去双细胞  (合并前 per-sample 去 doublet)
# 三组：HC vs RA vs RA_ILD
#
# 相比原脚本的改动（详见 README 的 review 部分）：
#   (1) 在 merge 之前对每个样本单独跑 scDblFinder 去双细胞
#   (2) 增加 percent.hb（血红蛋白，PBMC 易混 RBC）
#   (3) 增加 Batch 变量（注意 Batch 与 Group 存在混杂，见 README 警告）
#   (4) 兼容 Seurat v5（merge 后 JoinLayers）
#   (5) 保存 QC 小提琴图，便于复核阈值
# 本脚本仍只到 pre-Harmony；整合在 02 脚本。
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(decontX)        # 去环境 RNA 污染（也可 library(celda)）
  library(scDblFinder)
  library(SingleCellExperiment)
  library(ggplot2)
})

set.seed(1234)

all_dir  <- "all"                # 相对于工作目录的数据根目录
out_dir  <- "results/01_qc"      # 输出目录
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# ---- 1. 样本定义 ----
# 注意：HC + RA_ILD 来自测序批次 BM202404003A，RA 来自 BMS202408005A。
#       => Batch 与 Group 高度混杂，见 README「批次混杂」警告。
sample_info <- list(
  # HC 组 (2 例)
  "BM202404003A_002" = "HC",
  "BM202404003A_003" = "HC",
  # RA 组 (9 例)
  "BMS202408005A_007.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_009.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_010.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_011.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_014.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_015.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_016.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_019.filtered_feature_bc_matrix" = "RA",
  "BMS202408005A_021.filtered_feature_bc_matrix" = "RA",
  # RA_ILD 组 (9 例)
  "BM202404003A-004" = "RA_ILD",
  "BM202404003A-005" = "RA_ILD",
  "BM202404003A-006" = "RA_ILD",
  "BM202404003A-007" = "RA_ILD",
  "BM202404003A-008" = "RA_ILD",
  "BM202404003A-009" = "RA_ILD",
  "BM202404003A-010" = "RA_ILD",
  "BM202404003A-011" = "RA_ILD",
  "BM202404003A-012" = "RA_ILD"
)

# 从样本 id 提取批次前缀（第一个 _ 或 - 之前）
get_batch <- function(x) sub("[_-].*$", "", x)

# ---- 2. 逐样本读取 + per-sample 去双细胞 ----
seurat_list <- list()
qc_stats    <- list()

for (folder in names(sample_info)) {
  sample_id <- gsub("\\.filtered_feature_bc_matrix$", "", folder)
  group     <- sample_info[[folder]]
  data_dir  <- file.path(all_dir, folder)

  if (!dir.exists(data_dir)) {
    warning("目录不存在，跳过: ", data_dir)
    next
  }

  counts <- Read10X(data.dir = data_dir)

  # --- decontX 去环境 RNA 污染（per-sample，在建 Seurat 对象之前）---
  # decontX 默认是「校正 counts」而非「删除细胞」：它估计每个细胞的污染比例
  # (decontX_contamination)，并输出去污染后的矩阵 (decontXcounts)。
  # 下面用去污染矩阵替换原始 counts；是否再按污染比例剔除细胞见后面的阈值。
  sce_dx  <- SingleCellExperiment(list(counts = counts))
  raw_dir <- sub("filtered", "raw", data_dir)        # 若有未过滤 raw 矩阵作背景，估计更准
  if (dir.exists(raw_dir)) {
    bg     <- SingleCellExperiment(list(counts = Read10X(data.dir = raw_dir)))
    sce_dx <- decontX(sce_dx, background = bg)
  } else {
    sce_dx <- decontX(sce_dx)                         # 无 raw 背景则用自带聚类估计
  }
  contam     <- sce_dx$decontX_contamination
  dec_counts <- round(decontXcounts(sce_dx))          # 取整后的去污染 counts

  obj <- CreateSeuratObject(
    counts       = dec_counts,
    project      = sample_id,
    assay        = "RNA",
    min.cells    = 3,
    min.features = 200
  )
  obj$decontX_contamination <- contam[colnames(obj)]  # 对齐 CreateSeuratObject 过滤后的细胞

  # 可选：剔除污染比例过高的「污染细胞」（阈值看 QC 分布调，常用 0.2–0.5）
  obj <- subset(obj, subset = decontX_contamination < 0.2)

  obj$Sample <- sample_id
  obj$Group  <- factor(group, levels = c("HC", "RA", "RA_ILD"))
  obj$Batch  <- get_batch(sample_id)

  # --- per-sample doublet 检测（scDblFinder，在合并前做最准确）---
  sce <- SingleCellExperiment(list(counts = GetAssayData(obj, assay = "RNA", layer = "counts")))
  sce <- scDblFinder(sce)
  obj$scDblFinder_class <- sce$scDblFinder.class
  obj$scDblFinder_score <- sce$scDblFinder.score

  n_db <- sum(obj$scDblFinder_class == "doublet")
  obj  <- subset(obj, subset = scDblFinder_class == "singlet")

  qc_stats[[sample_id]] <- data.frame(
    Sample = sample_id, Group = group,
    cells_loaded = ncol(sce), doublets = n_db, singlets = ncol(obj)
  )

  seurat_list[[sample_id]] <- obj
  message(sprintf("  %-30s  %-7s  singlets: %-6d  (doublets removed: %d)",
                  sample_id, group, ncol(obj), n_db))
}

message("\n共读取 ", length(seurat_list), " 个样本")
qc_tab <- do.call(rbind, qc_stats)
write.csv(qc_tab, file.path(out_dir, "per_sample_doublet_stats.csv"), row.names = FALSE)

# ---- 3. 合并 ----
scRNA <- merge(
  seurat_list[[1]],
  y       = seurat_list[-1],
  add.cell.ids = names(seurat_list),
  project = "scRNA_RA_ILD"
)
# Seurat v5：merge 后各样本是独立 layer，先合回单层，后续标准流程与 v4 一致
if (inherits(scRNA[["RNA"]], "Assay5")) scRNA <- JoinLayers(scRNA)

rm(seurat_list); gc()
message(sprintf("合并完成: %d cells, %d genes", ncol(scRNA), nrow(scRNA)))
print(table(scRNA$Group))

# ---- 4. QC 指标 + 过滤 ----
scRNA[["percent.mt"]] <- PercentageFeatureSet(scRNA, pattern = "^MT-")
scRNA[["percent.rb"]] <- PercentageFeatureSet(scRNA, pattern = "^RP[SL]")
scRNA[["percent.hb"]] <- PercentageFeatureSet(scRNA, pattern = "^HB[AB]")

# 过滤前 QC 图
p_qc <- VlnPlot(scRNA, group.by = "Sample",
                features = c("nFeature_RNA", "nCount_RNA", "percent.mt", "percent.hb"),
                pt.size = 0, ncol = 2) & theme(axis.text.x = element_text(size = 6))
ggsave(file.path(out_dir, "QC_violin_preFilter.pdf"), p_qc, width = 14, height = 9)

scRNA <- subset(scRNA,
  subset = nFeature_RNA > 200 &
           nFeature_RNA < 4000 &
           nCount_RNA   < 50000 &
           percent.mt   < 15 &
           percent.hb   < 5)

message(sprintf("QC 后: %d cells", ncol(scRNA)))
print(table(scRNA$Group))

# ---- 5. 标准化 + HVG + Scale + PCA（pre-Harmony 检查点）----
scRNA <- NormalizeData(scRNA, normalization.method = "LogNormalize", scale.factor = 1e4)
scRNA <- FindVariableFeatures(scRNA, selection.method = "vst", nfeatures = 2000)
scRNA <- ScaleData(scRNA, vars.to.regress = c("percent.mt"))   # 默认仅 regress 线粒体；rb 视情况
scRNA <- RunPCA(scRNA, features = VariableFeatures(scRNA), npcs = 50, verbose = FALSE)

# 肘图，供 02 选 dims
ggsave(file.path(out_dir, "ElbowPlot.pdf"), ElbowPlot(scRNA, ndims = 50), width = 6, height = 4)

# ---- 6. 保存 ----
saveRDS(scRNA, file = "results/scRNA_preHarmony.rds")
message("已保存至 results/scRNA_preHarmony.rds")
