# ============================================================
# 05 - 细胞组成差异（统计检验，替代纯描述性比例图）
#   propeller(speckle)：对各亚群比例做组间检验
#   —— 直接对应「RA-ILD 经典↑ / 非经典↓」这一核心论点
# ============================================================

suppressPackageStartupMessages({
  library(Seurat)
  library(speckle)   # propeller
  library(ggplot2)
  library(dplyr)
})

out_dir <- "results/05_composition"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 大群层面
scRNA <- readRDS("results/scRNA_annotated.rds")
res_major <- propeller(clusters = scRNA$CellType,
                       sample   = scRNA$Sample,
                       group    = scRNA$Group)
write.csv(res_major, file.path(out_dir, "propeller_major.csv"))

# 单核三亚群层面
mono <- readRDS("results/mono.rds")
res_mono <- propeller(clusters = mono$MonoSubtype,
                      sample   = mono$Sample,
                      group    = mono$Group)
write.csv(res_mono, file.path(out_dir, "propeller_mono.csv"))

# 每个样本的比例条形图（展示样本间离散度，避免「细胞数即样本数」错觉）
prop_tab <- mono@meta.data %>%
  count(Sample, Group, MonoSubtype) %>%
  group_by(Sample) %>% mutate(frac = n / sum(n)) %>% ungroup()
p <- ggplot(prop_tab, aes(Sample, frac, fill = MonoSubtype)) +
  geom_col() + facet_grid(~Group, scales = "free_x", space = "free") +
  theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 6))
ggsave(file.path(out_dir, "mono_subtype_fraction_perSample.pdf"), p, width = 10, height = 5)

message("组成分析完成，结果见 ", out_dir)
print(res_mono)
