# ============================================================
# 03 - 大群注释：SingleR 自动注释 + canonical marker 人工核对
#   细化到 CD4T / CD8T / NK / B / Plasma / cMono / ncMono / DC / Platelet
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(SingleR)
  library(celldex)
  library(ggplot2)
  library(dplyr)
})
set.seed(1234)

out_dir <- "results/03_annotate"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

scRNA <- readRDS("results/scRNA_harmony.rds")

# ---- 1. SingleR 自动注释（Monaco 免疫参考，PBMC 适用）----
ref <- celldex::MonacoImmuneData()
expr <- GetAssayData(scRNA, assay = "RNA", layer = "data")
pred <- SingleR(test = expr, ref = ref,
                labels = ref$label.main,
                clusters = scRNA$seurat_clusters)   # 按 cluster 注释更稳
cluster_labels <- setNames(pred$labels, rownames(pred))
scRNA$SingleR_main <- cluster_labels[as.character(scRNA$seurat_clusters)]
write.csv(data.frame(cluster = rownames(pred), label = pred$labels),
          file.path(out_dir, "SingleR_cluster_labels.csv"), row.names = FALSE)

# ---- 2. canonical markers 人工核对 ----
markers <- list(
  `CD4 T`   = c("CD3D","CD4","IL7R","CCR7"),
  `CD8 T`   = c("CD3D","CD8A","GZMK","NKG7"),
  NK        = c("KLRD1","NKG7","GNLY","FGFBP2"),
  `B`       = c("MS4A1","CD79A","IGHD","PAX5"),
  Plasma    = c("MZB1","JCHAIN","IGHA1"),
  cMono     = c("CD14","S100A8","S100A9","LYZ"),
  ncMono    = c("FCGR3A","CX3CR1","LYPD2","CDKN1C"),  # FCGR3A = CD16
  DC        = c("FCER1A","CD1C","CLEC9A","LILRA4"),
  Platelet  = c("PPBP","PF4","GP9","TUBB1")
)
p_dot <- DotPlot(scRNA, features = markers, group.by = "seurat_clusters") +
  RotatedAxis() + theme(axis.text.x = element_text(size = 7))
ggsave(file.path(out_dir, "DotPlot_canonical_markers.pdf"), p_dot, width = 16, height = 7)

# FindAllMarkers 备查
all_mk <- FindAllMarkers(scRNA, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
write.csv(all_mk, file.path(out_dir, "FindAllMarkers.csv"), row.names = FALSE)

# ---- 3. 人工 cluster -> 细胞类型 映射 ----
# !! 看完上面两张图后，按实际 cluster 号填写下面的对照表再取消注释运行 !!
# celltype_map <- c(
#   "0" = "CD4 T", "1" = "CD8 T", "2" = "NK", "3" = "cMono",
#   "4" = "B", "5" = "ncMono", "6" = "Plasma", "7" = "DC", "8" = "Platelet"
# )
# scRNA$CellType <- factor(celltype_map[as.character(scRNA$seurat_clusters)])
# Idents(scRNA) <- "CellType"
# ggsave(file.path(out_dir, "UMAP_CellType.pdf"),
#        DimPlot(scRNA, label = TRUE) + ggtitle("Cell types"), width = 8, height = 6)

saveRDS(scRNA, "results/scRNA_annotated.rds")
message("已保存 results/scRNA_annotated.rds  —— 请先核对图表，填好 celltype_map 再继续")
