# ============================================================
# 02 - Harmony 整合 + 聚类 + UMAP
# 关键：按 Sample 去批次（绝不能按 Group 整合，否则会把生物学差异抹掉）
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(harmony)
  library(ggplot2)
})
set.seed(1234)

out_dir <- "results/02_cluster"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

scRNA <- readRDS("results/scRNA_preHarmony.rds")

dims_use <- 1:30   # 参考 01 的 ElbowPlot 调整

# ---- 1. Harmony 整合（group.by.vars = Sample）----
scRNA <- RunHarmony(scRNA, group.by.vars = "Sample",
                    reduction.use = "pca", reduction.save = "harmony",
                    plot_convergence = FALSE)

# ---- 2. 聚类 + UMAP（基于 harmony）----
scRNA <- FindNeighbors(scRNA, reduction = "harmony", dims = dims_use)
scRNA <- FindClusters(scRNA, resolution = 0.5)   # 大群用 0.5；单核细分在 04 用低分辨率
scRNA <- RunUMAP(scRNA, reduction = "harmony", dims = dims_use)

# ---- 3. 整合质量检查：UMAP 按 Sample / Group / cluster 上色 ----
p1 <- DimPlot(scRNA, group.by = "Sample",  raster = FALSE) + ggtitle("by Sample")
p2 <- DimPlot(scRNA, group.by = "Group",   raster = FALSE) + ggtitle("by Group")
p3 <- DimPlot(scRNA, group.by = "Batch",   raster = FALSE) + ggtitle("by Batch")
p4 <- DimPlot(scRNA, label = TRUE,         raster = FALSE) + ggtitle("clusters")
ggsave(file.path(out_dir, "UMAP_integration_check.pdf"),
       (p1 | p2) / (p3 | p4), width = 14, height = 11)

# 可选：定量评估整合（需要 lisi 包）
# library(lisi)
# emb  <- Embeddings(scRNA, "harmony")[, dims_use]
# meta <- scRNA@meta.data[, c("Sample","Group")]
# il   <- compute_lisi(emb, meta, c("Sample","Group"))
# write.csv(summary(il), file.path(out_dir, "lisi_summary.csv"))

saveRDS(scRNA, "results/scRNA_harmony.rds")
message("已保存 results/scRNA_harmony.rds")
