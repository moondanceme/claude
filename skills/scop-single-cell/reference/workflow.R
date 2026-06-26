# ============================================================
# SCOP 可运行配方集 (mengxu98/scop)
# 从一个含 meta.data 列 Sample / Group 的 Seurat 对象出发。
# 按需取用各段；不要无脑整段跑。
# ============================================================

library(scop)

save_plot <- function(p, file, w = 7, h = 6) {
  if (is.list(p) && !inherits(p, "ggplot") && !is.null(p$plot)) p <- p$plot
  ggplot2::ggsave(file, p, width = w, height = h, limitsize = FALSE)
}

# ---- 0. QC（可选，若已在 Seurat 侧做过则跳过）----
# srt <- RunCellQC(srt, qc_metrics = c("doublets","outlier","umi","gene","mito"))
# srt <- subset(srt, subset = CellQC == "Pass")
# srt <- RunDecontX(srt)   # 去环境 RNA（也可在 Seurat 侧用 decontX 做）

# ---- 1. 整合 + 降维聚类（多样本）----
# integration_method 可换 CCA / RPCA / fastMNN / Scanorama / scVI 等
srt <- integration_scop(srt, batch = "Sample", integration_method = "Harmony")
# 单样本时改用： srt <- standard_scop(srt)

# 看实际 reduction 名（后续绘图 reduction= 用得到；也可直接传 NULL 自动选）
print(Reductions(srt))

# ---- 2. UMAP 可视化 ----
save_plot(CellDimPlot(srt, group.by = "seurat_clusters", reduction = NULL,
                      label = TRUE, theme_use = "theme_blank"),
          "01_umap_clusters.pdf")
save_plot(CellDimPlot(srt, group.by = "seurat_clusters", split.by = "Group", ncol = 3),
          "02_umap_byGroup.pdf", w = 15, h = 6)

# ---- 3. 注释（参考映射，避免纯手动）----
# data("ref_scMCA")  # 包内自带的一个参考；也可用自己的参考 Seurat 对象
# srt <- RunKNNPredict(srt, ref_scMCA = ref_scMCA)         # bulk/单细胞参考
# 或： srt <- RunSingleR(srt, ref = ref_obj, ref_group = "celltype")
# 注释完把结果列设为分组，例如 srt$CellType

# ---- 4. marker 着色 / 点图 / 热图 ----
markers <- c("CD3D","CD8A","KLRD1","MS4A1","CD14","FCGR3A","FCER1A","PPBP")
save_plot(FeatureDimPlot(srt, features = markers, ncol = 4), "03_markers_umap.pdf", w = 15, h = 8)
save_plot(GroupHeatmap(srt, features = markers, group.by = "seurat_clusters",
                       show_row_names = TRUE), "04_marker_heatmap.pdf", w = 8, h = 6)

# ---- 5. 细胞组成（出图 + 统计检验）----
save_plot(CellStatPlot(srt, stat.by = "seurat_clusters", group.by = "Group",
                       plot_type = "bar", stat_type = "percent", position = "stack",
                       label = TRUE), "05_composition_bar.pdf")
save_plot(CellStatPlot(srt, stat.by = "seurat_clusters", group.by = "Group",
                       plot_type = "ring"), "05_composition_ring.pdf", w = 9, h = 5)
# 统计：组间各亚群比例差异（择一）
# srt <- RunPropeller(srt, cluster_by = "seurat_clusters", sample_by = "Sample", group_by = "Group")
# srt <- RunscCODA(srt, cluster_by = "seurat_clusters", sample_by = "Sample", group_by = "Group")

# ---- 6. 表达比较（自带显著性）----
save_plot(FeatureStatPlot(srt, stat.by = c("CD14","FCGR3A"), group.by = "Group",
                          plot_type = "violin", add_box = TRUE,
                          multiplegroup_comparisons = TRUE),
          "06_expr_byGroup.pdf", w = 8, h = 5)

# ---- 7. 差异表达 + 富集（探索性：细胞级；正式结论请用 pseudobulk）----
srt <- RunDEtest(srt, group_by = "Group", fc.threshold = 1, only.pos = FALSE)
save_plot(VolcanoPlot(srt, group_by = "Group"), "07_volcano.pdf", w = 9, h = 7)
srt <- RunEnrichment(srt, group_by = "Group", db = "GO_BP", species = "Homo_sapiens",
                     DE_threshold = "p_val_adj < 0.05")
save_plot(EnrichmentPlot(srt, group_by = "Group", plot_type = "bar"), "08_enrich.pdf", w = 9, h = 8)
# GSEA 版本（保留方向）：
# srt <- RunGSEA(srt, group_by = "Group", db = "GO_BP", species = "Homo_sapiens")
# save_plot(GSEAPlot(srt, group_by = "Group"), "08_gsea.pdf", w = 9, h = 7)

# ---- 8. 轨迹 / 拟时序 + 动态热图 ----
srt <- RunSlingshot(srt, group.by = "seurat_clusters", reduction = NULL)
# 或用 Monocle3： srt <- RunMonocle3(srt)
srt <- RunDynamicFeatures(srt, lineages = "Lineage1", n_candidates = 200)
save_plot(DynamicHeatmap(srt, lineages = "Lineage1", use_fitted = TRUE, n_split = 5,
                         species = "Homo_sapiens", db = "GO_BP", show_row_names = FALSE),
          "09_dynamic_heatmap.pdf", w = 10, h = 9)
save_plot(LineagePlot(srt, lineages = "Lineage1"), "10_lineage.pdf")

# ---- 9. 转录因子调控网络 ----
# srt <- RunSCENIC(srt, species = "Homo_sapiens")   # 需要 cisTarget 数据库
# save_plot(SCENICPlot(srt), "11_scenic.pdf")

message("done")
