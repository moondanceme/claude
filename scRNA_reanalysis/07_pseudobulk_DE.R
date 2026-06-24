# ============================================================
# 07 - 伪bulk差异表达（核心修复：消除 pseudoreplication）
#   按「样本 × 亚群」聚合 -> DESeq2 组间比较
#   这是替代原文「细胞级 FDR」的关键步骤
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(DESeq2)
  library(dplyr)
  library(tibble)
})

out_dir <- "results/07_pseudobulk"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

mono <- readRDS("results/mono_traj.rds")   # 含 MonoSubtype / Group / Sample

# ---- 1. 按 样本×亚群 聚合成伪bulk ----
agg <- AggregateExpression(mono, assays = "RNA",
                           group.by = c("MonoSubtype", "Sample"),
                           return.seurat = FALSE)$RNA
# 列名形如 "cMono_BM202404003A_002"

# 样本元数据
meta <- mono@meta.data %>%
  distinct(Sample, Group, Batch)

run_deseq <- function(subtype, contrast) {
  cols <- grep(paste0("^", subtype, "_"), colnames(agg), value = TRUE)
  if (length(cols) < 4) { message("亚群样本太少，跳过: ", subtype); return(NULL) }
  mat <- round(as.matrix(agg[, cols]))
  samp <- sub(paste0("^", subtype, "_"), "", cols)
  cd <- data.frame(Sample = samp) %>% left_join(meta, by = "Sample")
  rownames(cd) <- cols
  cd$Group <- factor(cd$Group, levels = c("HC","RA","RA_ILD"))

  # 只保留每组至少 ~10 reads 的基因
  keep <- rowSums(mat >= 10) >= 2
  mat  <- mat[keep, ]

  # 注意：Batch 与 Group 在 RA 上完全混杂，无法同时放入模型；
  #       因此设计仅用 ~Group，并在文中说明此局限。
  dds <- DESeqDataSetFromMatrix(mat, colData = cd, design = ~ Group)
  dds <- DESeq(dds)
  res <- results(dds, contrast = contrast) %>%
    as.data.frame() %>% rownames_to_column("gene") %>%
    arrange(padj)
  res$subtype  <- subtype
  res$contrast <- paste(contrast[2], "vs", contrast[3])
  res
}

subtypes  <- levels(mono$MonoSubtype)
contrasts <- list(c("Group","RA_ILD","HC"),
                  c("Group","RA","HC"),
                  c("Group","RA_ILD","RA"))

all_res <- list()
for (st in subtypes) for (ct in contrasts) {
  r <- tryCatch(run_deseq(st, ct), error = function(e) {message(e$message); NULL})
  if (!is.null(r)) all_res[[paste(st, ct[2], ct[3], sep = "_")]] <- r
}
res_df <- bind_rows(all_res)
write.csv(res_df, file.path(out_dir, "pseudobulk_DESeq2_all.csv"), row.names = FALSE)

# SPI1 / GPX4 重点查看
focus <- res_df %>% filter(gene %in% c("SPI1","GPX4","FCGR3A","CD14")) %>%
  arrange(gene, subtype, contrast)
write.csv(focus, file.path(out_dir, "focus_SPI1_GPX4.csv"), row.names = FALSE)
print(focus)

message("伪bulk DE 完成（n=HC2/RA9/RA_ILD9，HC 样本偏少，解读需谨慎）")
