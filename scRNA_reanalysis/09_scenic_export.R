# ============================================================
# 09 - SCENIC 输入导出（转录因子调控网络）
#   R 端只负责导出表达矩阵 -> loom，真正的 SCENIC 在 Python(pySCENIC) 跑
#   重点：pySCENIC 多次运行取稳定 regulon，再讲「SPI1 调控 xx%」
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(SCopeLoomR)   # BiocManager::install("aertslab/SCopeLoomR")
})

out_dir <- "results/09_scenic"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

mono <- readRDS("results/mono_traj.rds")

# 导出 counts 矩阵为 loom
mat <- as.matrix(GetAssayData(mono, assay = "RNA", layer = "counts"))
loom <- build_loom(file.path(out_dir, "mono_counts.loom"), dgem = mat)
add_col_attr(loom, key = "MonoSubtype", value = as.character(mono$MonoSubtype))
add_col_attr(loom, key = "Group",       value = as.character(mono$Group))
close_loom(loom)

message("已导出 ", file.path(out_dir, "mono_counts.loom"))

# ---------------------------------------------------------------
# 之后在命令行用 pySCENIC（建议跑 50-100 次取稳定 regulon）：
#
#   for i in $(seq 1 100); do
#     pyscenic grn   ... --output adj_$i.tsv    # GRNBoost2 / GENIE3
#     pyscenic ctx ...   --output reg_$i.csv    # cisTarget motif 富集
#     pyscenic aucell ... --output auc_$i.csv   # AUCell 活性
#   done
#
# 再统计 SPI1 regulon 在 N 次运行中的出现频率与稳定 target 基因，
# 用「在 ≥80% 运行中出现的 target」来计算 SPI1 调控比例，避免单次 GENIE3 的不稳定。
# ---------------------------------------------------------------
