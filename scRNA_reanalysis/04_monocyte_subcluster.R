# ============================================================
# 04 - 单核细胞取子集 + 再聚类 + 三亚群注释
#   cMono(CD14++CD16-) / intMono(CD14++CD16+) / ncMono(CD14+CD16++)
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(harmony)
  library(ggplot2)
})
set.seed(1234)

out_dir <- "results/04_mono"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

scRNA <- readRDS("results/scRNA_annotated.rds")

# ---- 1. 取单核（含 DC 可一起取再剔除，视注释而定）----
mono <- subset(scRNA, subset = CellType %in% c("cMono", "ncMono"))  # 若 DC 混入可加 "DC"

# 子集内重新走一遍降维（子集后 HVG 会变）
mono <- NormalizeData(mono)
mono <- FindVariableFeatures(mono, nfeatures = 2000)
mono <- ScaleData(mono, vars.to.regress = "percent.mt")
mono <- RunPCA(mono, npcs = 30, verbose = FALSE)
mono <- RunHarmony(mono, group.by.vars = "Sample", reduction.use = "pca",
                   reduction.save = "harmony")
mono <- FindNeighbors(mono, reduction = "harmony", dims = 1:20)
mono <- FindClusters(mono, resolution = 0.2)     # 与原文一致的低分辨率
mono <- RunUMAP(mono, reduction = "harmony", dims = 1:20)

# ---- 2. 用 CD14 / FCGR3A 定义三亚群 ----
feats <- c("CD14","FCGR3A","S100A8","S100A9","CX3CR1","CDKN1C","IL1B","CCL3","HLA-DRA")
ggsave(file.path(out_dir, "DotPlot_mono_subset.pdf"),
       DotPlot(mono, features = feats, group.by = "seurat_clusters") + RotatedAxis(),
       width = 10, height = 5)
ggsave(file.path(out_dir, "FeaturePlot_CD14_CD16.pdf"),
       FeaturePlot(mono, c("CD14","FCGR3A"), order = TRUE), width = 10, height = 4)

# 子聚类稳定性（轮廓系数，需要 cluster + bluster）
# library(bluster); library(cluster)
# sil <- approxSilhouette(Embeddings(mono,"harmony")[,1:20], mono$seurat_clusters)
# write.csv(as.data.frame(sil), file.path(out_dir,"silhouette.csv"))

# ---- 3. 人工映射三亚群（核对上图后填写）----
# mono_map <- c("0" = "cMono", "1" = "intMono", "2" = "ncMono")
# mono$MonoSubtype <- factor(mono_map[as.character(mono$seurat_clusters)],
#                            levels = c("cMono","intMono","ncMono"))
# Idents(mono) <- "MonoSubtype"

saveRDS(mono, "results/mono.rds")
message("已保存 results/mono.rds —— 核对后填 mono_map 再继续")
