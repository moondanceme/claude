# ============================================================
# 08 - 富集分析（基于伪bulk DE 结果，规范背景与方向）
#   GSEA（全部基因按统计量排序）+ ORA（显著基因），并报告命中基因数
# ============================================================

suppressPackageStartupMessages({
  library(clusterProfiler)
  library(org.Hs.eg.db)
  library(dplyr)
  library(ggplot2)
})

out_dir <- "results/08_enrichment"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

res_df <- read.csv("results/07_pseudobulk/pseudobulk_DESeq2_all.csv")

# 针对某一亚群 + 对比做富集（示例：cMono RA_ILD vs HC）
do_enrich <- function(subtype, contrast_str) {
  sub <- res_df %>% filter(subtype == !!subtype, contrast == !!contrast_str,
                           !is.na(stat))
  if (nrow(sub) < 50) return(invisible(NULL))

  # ---- GSEA：用全部基因的 Wald stat 排序（保留方向）----
  gl <- sub$stat; names(gl) <- sub$gene
  gl <- sort(gl[!duplicated(names(gl))], decreasing = TRUE)
  gse <- gseGO(gl, OrgDb = org.Hs.eg.db, keyType = "SYMBOL",
               ont = "BP", minGSSize = 10, maxGSSize = 500, pvalueCutoff = 0.05)
  tag <- paste0(subtype, "_", gsub(" ", "", contrast_str))
  write.csv(as.data.frame(gse), file.path(out_dir, paste0("GSEA_GO_", tag, ".csv")),
            row.names = FALSE)

  # ---- ORA：显著基因（padj<0.05）----
  sig <- sub %>% filter(padj < 0.05) %>% pull(gene)
  if (length(sig) >= 10) {
    ora <- enrichGO(sig, OrgDb = org.Hs.eg.db, keyType = "SYMBOL",
                    ont = "BP", pvalueCutoff = 0.05, qvalueCutoff = 0.05,
                    universe = sub$gene)   # 背景 = 检测到的基因，而非全基因组
    write.csv(as.data.frame(ora), file.path(out_dir, paste0("ORA_GO_", tag, ".csv")),
              row.names = FALSE)
  }
  message("完成富集: ", tag)
}

# 对所有亚群×对比批量跑
combos <- res_df %>% distinct(subtype, contrast)
for (i in seq_len(nrow(combos)))
  do_enrich(combos$subtype[i], combos$contrast[i])

# 重点关注铁/铁死亡相关条目，可在结果 csv 中 grep:
#   "iron", "ferroptosis", "oxidative phosphorylation", "respiratory"
message("富集完成，结果见 ", out_dir, "（务必核对每条通路的 core_enrichment 命中基因数）")
