# ============================================================
# 10 - SCOP 可视化 (mengxu98/scop)
#   用 SCOP 的绘图函数对前面产出的 Seurat 对象做出版级可视化
#   安装：remotes::install_github("mengxu98/scop")
#   说明：本脚本只用 SCOP 的「纯 R 绘图/分析」函数，不依赖 conda/python；
#         RNA velocity / PAGA 等需要 python 的功能未包含。
#   依赖前置产物：results/scRNA_annotated.rds (含 CellType)、
#                 results/mono_traj.rds (含 MonoSubtype / Group / pseudotime)
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(scop)
  library(ggplot2)
})

out_dir <- "results/10_scop"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

save_plot <- function(p, name, w = 7, h = 6) {
  # SCOP 的热图函数返回 list，取其中的 $plot；其余返回 ggplot/patchwork
  if (is.list(p) && !inherits(p, "ggplot") && !is.null(p$plot)) p <- p$plot
  ggsave(file.path(out_dir, name), p, width = w, height = h, limitsize = FALSE)
}

# 注意 reduction 名要与你 Seurat 对象里的一致：Seurat 默认 RunUMAP 生成 "umap"
# 若报错可先看 Reductions(scRNA) 确认实际名字
RED <- "umap"

# ============================================================
# A. 大群层面（scRNA_annotated.rds）
# ============================================================
scRNA <- readRDS("results/scRNA_annotated.rds")

# A1. UMAP：细胞类型（带标签，干净背景）
save_plot(CellDimPlot(scRNA, group.by = "CellType", reduction = RED,
                      label = TRUE, theme_use = "theme_blank"),
          "A1_UMAP_CellType.pdf")

# A2. UMAP 按组拆分（HC / RA / RA_ILD 并排）
save_plot(CellDimPlot(scRNA, group.by = "CellType", reduction = RED,
                      split.by = "Group", ncol = 3),
          "A2_UMAP_CellType_byGroup.pdf", w = 15, h = 6)

# A3. marker 基因表达（UMAP 着色）
markers <- c("CD3D","CD8A","KLRD1","MS4A1","MZB1",
             "CD14","FCGR3A","FCER1A","PPBP")
save_plot(FeatureDimPlot(scRNA, features = markers, reduction = RED, ncol = 3),
          "A3_FeatureDimPlot_markers.pdf", w = 13, h = 11)

# A4. 各组细胞组成（堆叠柱 + 环形；替代/补充 propeller 的可视化）
save_plot(CellStatPlot(scRNA, stat.by = "CellType", group.by = "Group",
                       plot_type = "bar", stat_type = "percent",
                       position = "stack", label = TRUE),
          "A4_composition_bar.pdf", w = 6, h = 6)
save_plot(CellStatPlot(scRNA, stat.by = "CellType", group.by = "Group",
                       plot_type = "ring"),
          "A4_composition_ring.pdf", w = 9, h = 5)

# A5. marker 分组热图
save_plot(GroupHeatmap(scRNA, features = markers, group.by = "CellType",
                       show_row_names = TRUE),
          "A5_GroupHeatmap_markers.pdf", w = 8, h = 6)

# ============================================================
# B. 单核三亚群（mono_traj.rds）
# ============================================================
mono <- readRDS("results/mono_traj.rds")

# B1. 单核亚群 UMAP
save_plot(CellDimPlot(mono, group.by = "MonoSubtype", reduction = RED, label = TRUE),
          "B1_UMAP_MonoSubtype.pdf")

# B2. 亚群比例按组
save_plot(CellStatPlot(mono, stat.by = "MonoSubtype", group.by = "Group",
                       plot_type = "bar", stat_type = "percent", label = TRUE),
          "B2_mono_composition.pdf", w = 6, h = 6)

# B3. SPI1 / GPX4 在各组的表达（小提琴 + 组间显著性，直接服务核心论点）
save_plot(FeatureStatPlot(mono, stat.by = c("SPI1","GPX4"), group.by = "Group",
                          plot_type = "violin", add_box = TRUE,
                          multiplegroup_comparisons = TRUE),
          "B3_SPI1_GPX4_byGroup.pdf", w = 8, h = 5)

# B4. SPI1 / GPX4 在三亚群（按组拆分）
save_plot(FeatureStatPlot(mono, stat.by = c("SPI1","GPX4"),
                          group.by = "MonoSubtype", split.by = "Group",
                          plot_type = "box", add_point = TRUE),
          "B4_SPI1_GPX4_bySubtype.pdf", w = 11, h = 5)

# B5. pseudotime 投影到 UMAP
save_plot(FeatureDimPlot(mono, features = "pseudotime", reduction = RED),
          "B5_pseudotime_UMAP.pdf")

# ============================================================
# C. 拟时序动态热图（SCOP 算 dynamic features，沿 06 的 pseudotime）
# ============================================================
mono <- RunDynamicFeatures(mono, lineages = "pseudotime", n_candidates = 200)
save_plot(DynamicHeatmap(mono, lineages = "pseudotime", use_fitted = TRUE,
                         n_split = 5, species = "Homo_sapiens", db = "GO_BP",
                         show_row_names = FALSE),
          "C1_DynamicHeatmap_pseudotime.pdf", w = 10, h = 9)

# ============================================================
# D.（探索性）SCOP 的 DE + 富集可视化
#    注意：RunDEtest 是「细胞级」Wilcoxon，仅供探索/出图；
#          统计结论以 07 的伪bulk DESeq2 为准。
# ============================================================
mono <- RunDEtest(mono, group_by = "Group", fc.threshold = 1, only.pos = FALSE)
save_plot(DEtestPlot(mono, group_by = "Group", plot_type = "volcano"),
          "D1_Volcano_byGroup.pdf", w = 9, h = 7)

mono <- RunEnrichment(mono, group_by = "Group", db = "GO_BP",
                      species = "Homo_sapiens", DE_threshold = "p_val_adj < 0.05")
save_plot(EnrichmentPlot(mono, group_by = "Group", plot_type = "bar"),
          "D2_Enrichment_bar.pdf", w = 9, h = 8)

message("SCOP 可视化完成，结果见 ", out_dir)
