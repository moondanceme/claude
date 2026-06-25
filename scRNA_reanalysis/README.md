# 单细胞重分析流程 (RA-ILD 单核细胞)

> 说明：这些脚本在本远程环境**未运行**——容器里没有安装 R，也没有 10x 原始数据
> （`all/` 矩阵在你本地/HPC 上）。脚本已写成可直接在数据所在机器上运行。

## 运行顺序

| 脚本 | 作用 | 产出 |
|------|------|------|
| `01_integrate.R` | 读取 + per-sample 去双细胞(scDblFinder) + QC | `results/scRNA_preHarmony.rds` |
| `02_harmony_cluster.R` | Harmony 按 Sample 整合 + 聚类 + UMAP | `results/scRNA_harmony.rds` |
| `03_annotate.R` | SingleR + canonical marker 大群注释 | `results/scRNA_annotated.rds` |
| `04_monocyte_subcluster.R` | 单核取子集 + 三亚群 | `results/mono.rds` |
| `05_composition.R` | propeller 组成差异**统计检验** | `results/05_composition/` |
| `06_trajectory.R` | CytoTRACE2 + Monocle3 拟时序 | `results/mono_traj.rds` |
| `07_pseudobulk_DE.R` | **伪bulk DESeq2**（核心修复） | `results/07_pseudobulk/` |
| `08_enrichment.R` | GSEA + ORA（规范背景/方向） | `results/08_enrichment/` |
| `09_scenic_export.R` | 导出 loom 给 pySCENIC | `results/09_scenic/` |

> `03` 和 `04` 里有需要**人工核对图后填写 cluster→细胞类型对照表**的地方（已注释标出），
> 填好再跑后续脚本。

## 依赖
```r
# CRAN
install.packages(c("Seurat","harmony","ggplot2","dplyr","tibble"))
# Bioconductor
BiocManager::install(c("decontX","scDblFinder","SingleR","celldex","SingleCellExperiment",
                       "DESeq2","clusterProfiler","org.Hs.eg.db","speckle",
                       "monocle3","SeuratWrappers","SCopeLoomR"))
# GitHub
remotes::install_github("digitalcytometry/cytotrace2", subdir = "cytotrace2_r")
```

---

## 对 `01_integrate.R` 原脚本的 Review

**做得对的：** 三组定义清晰、QC 阈值与原文一致、加了 percent.rb、按样本设 `orig.ident`、merge 后 `gc()`。

**必须修的问题（已在新版 01 中处理）：**

1. **❗批次与分组完全混杂（最严重）。** HC + RA_ILD 都来自测序批次 `BM202404003A`，
   而 RA 全部来自 `BMS202408005A`。也就是说「RA vs 其它」的差异和「批次差异」无法区分。
   Harmony 按 Sample 整合能缓解、但**不能根除**这种结构性混杂。
   → 建议：(a) 文中明确披露；(b) 主结论尽量落在 HC vs RA_ILD（同批次）这条更干净的对比上；
   (c) 关键基因(SPI1/GPX4)务必用蛋白/流式在独立大队列上验证。这一条决定结论强度，无法靠代码消除。

2. **缺去双细胞。** 原脚本完全没有 doublet 处理。已加 `scDblFinder`（合并前 per-sample 做最准）。

3. **HC 只有 2 例。** 伪bulk DE 里 HC 端自由度极低，RA_ILD vs HC 的 padj 需保守解读；
   建议尽量补 HC 样本。

4. **Seurat v5 兼容。** v5 中 `merge` 会把各样本拆成独立 layer，原脚本后续 `NormalizeData`/`ScaleData`
   行为与 v4 不同。已加 `JoinLayers` 保证与原流程一致。

5. **`ScaleData` 同时 regress `percent.rb`** 可能过度回归（核糖体基因本身有生物学信息）。
   新版默认只 regress `percent.mt`，rb 视情况再加。

6. **没有去环境RNA、没有 hb 过滤、没有保存 QC 图。** 已补 `decontX` 去环境RNA污染（per-sample，
   `Read10X` 之后、建对象之前，用校正后的 counts 继续）、`percent.hb` 过滤、QC 小提琴/肘图输出。
   decontX 只校正 counts、**不按污染分数删细胞**（无生物学依据的硬阈值会无谓损失信息）；
   `decontX_contamination` 仅留作 QC 可视化。

7. **「整合」尚未发生。** 文件名是 `01_integrate` 但实际只到 pre-Harmony，真正整合在 `02`。命名上注意。

**结论：** 前半部分骨架没错，但 **(1) 批次混杂** 和 **(2) 缺去双细胞** 是两个必须处理的点，
其余为稳健性增强。整条管线最关键的方法学修复是 `07` 的**伪bulk**——它替代原文的细胞级 P 值，
是单细胞结论能否成立的地基。
