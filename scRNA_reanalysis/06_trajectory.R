# ============================================================
# 06 - 分化轨迹：CytoTRACE2 定干性 + Monocle3 拟时序
#   根的方向用 CytoTRACE2 独立验证，避免「用干性定根再用轨迹证明干性」的循环论证
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(monocle3)
  library(SeuratWrappers)
  library(ggplot2)
})
set.seed(1234)

out_dir <- "results/06_trajectory"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

mono <- readRDS("results/mono.rds")

# ---- 1. CytoTRACE2 干性评分 ----
# remotes::install_github("digitalcytometry/cytotrace2", subdir = "cytotrace2_r")
if (requireNamespace("CytoTRACE2", quietly = TRUE)) {
  ct <- CytoTRACE2::cytotrace2(mono, is_seurat = TRUE, species = "human",
                               slot_type = "counts")
  mono$CytoTRACE2_Score <- ct$CytoTRACE2_Score
  ggsave(file.path(out_dir, "UMAP_CytoTRACE2.pdf"),
         FeaturePlot(mono, "CytoTRACE2_Score") & scale_color_viridis_c(),
         width = 6, height = 5)
  ggsave(file.path(out_dir, "Vln_CytoTRACE2_bySubtype.pdf"),
         VlnPlot(mono, "CytoTRACE2_Score", group.by = "MonoSubtype"),
         width = 6, height = 4)
}

# ---- 2. Monocle3 轨迹 ----
cds <- as.cell_data_set(mono)
cds <- cluster_cells(cds, reduction_method = "UMAP")
cds <- learn_graph(cds, use_partition = TRUE)

# 根：取 CytoTRACE2 评分最高 / 经典单核所在区域。这里用经典单核为根更稳健。
root_cells <- colnames(cds)[mono$MonoSubtype == "cMono"]
cds <- order_cells(cds, root_cells = root_cells)
mono$pseudotime <- pseudotime(cds)

ggsave(file.path(out_dir, "Monocle3_pseudotime.pdf"),
       plot_cells(cds, color_cells_by = "pseudotime",
                  label_branch_points = FALSE, label_leaves = FALSE),
       width = 6, height = 5)
ggsave(file.path(out_dir, "Monocle3_bySubtype.pdf"),
       plot_cells(cds, color_cells_by = "MonoSubtype"),
       width = 6, height = 5)

# ---- 3. 沿拟时序找显著变化基因（graph_test）----
graph_res <- graph_test(cds, neighbor_graph = "principal_graph", cores = 4)
graph_res <- subset(graph_res, q_value < 0.05)
graph_res <- graph_res[order(-graph_res$morans_I), ]
write.csv(graph_res, file.path(out_dir, "graph_test_DEgenes.csv"))

# ---- 4. 推荐：连续建模代替硬切 bin1/bin2（tradeSeq，按需取消注释）----
# 沿拟时序 + 组别交互，比把细胞硬切两段更可信
# library(tradeSeq)
# ... fitGAM(counts, pseudotime, cellWeights, conditions = mono$Group) ...

saveRDS(mono, "results/mono_traj.rds")
saveRDS(cds,  "results/mono_cds.rds")
message("轨迹分析完成，结果见 ", out_dir)
