---
name: scop-single-cell
description: >
  Use the SCOP R package (github mengxu98/scop, the maintained successor of SCP) for
  single-cell RNA-seq analysis and publication-quality visualization. Trigger this skill
  whenever the user wants to analyze or plot scRNA-seq data with SCOP: QC and decontamination,
  normalization, batch integration, clustering, cell-type annotation, cell composition /
  differential abundance, differential expression, GO/KEGG/GSEA enrichment, trajectory /
  pseudotime, gene regulatory networks (SCENIC), or any SCOP plot such as CellDimPlot,
  FeatureDimPlot, CellStatPlot, FeatureStatPlot, GroupHeatmap, DynamicHeatmap, VolcanoPlot,
  or EnrichmentPlot. Works on Seurat objects.
---

# SCOP single-cell analysis & visualization

SCOP (`mengxu98/scop`) is an all-in-one R toolkit for single-cell / spatial omics. It operates
on **Seurat objects** and is especially strong at **publication-quality plots that carry built-in
statistics**. Use it for the visualization and exploratory layer; for rigorous group-level
statistics prefer pseudobulk methods (see "Statistical caution" below).

## Setup

```r
# install (R >= 4.1)
if (!require("remotes")) install.packages("remotes")
remotes::install_github("mengxu98/scop")
library(scop)        # also attaches/uses Seurat
```

Pure-R plotting and most analysis functions need no Python. A subset (RNA velocity `RunSCVELO`,
`RunPAGA`, `RunPalantir`, scVI, CellTypist, etc.) needs a conda env via `PrepareEnv()`. Avoid those
unless the user explicitly asks; everything below is Python-free.

## Conventions (read first)

- Every function takes a Seurat object as the first arg, usually named `srt`.
- Grouping args: `group.by` (color/group), `split.by` (facet), `stat.by` (the variable being
  counted/plotted). These are **meta.data column names**, or gene names for feature plots.
- `reduction =` must match a reduction that exists in the object. Seurat's `RunUMAP` stores
  `"umap"` (lowercase); SCOP's `standard_scop` may store `"StandardpcaUMAP2D"` etc. If unsure,
  check `Reductions(srt)` or pass `reduction = NULL` to let SCOP auto-pick `DefaultReduction(srt)`.
- **Return types:** `*DimPlot` / `*StatPlot` return a ggplot/patchwork (use `ggsave` directly).
  Heatmaps (`GroupHeatmap`, `DynamicHeatmap`, `FeatureHeatmap`) return a **list**; the figure is in
  `$plot`. A safe saver:
  ```r
  save_plot <- function(p, file, w = 7, h = 6) {
    if (is.list(p) && !inherits(p, "ggplot") && !is.null(p$plot)) p <- p$plot
    ggplot2::ggsave(file, p, width = w, height = h, limitsize = FALSE)
  }
  ```
- `species = "Homo_sapiens"` or `"Mus_musculus"` for enrichment/trajectory-enrichment functions.
- This fork's standard pipelines are **lowercase**: `standard_scop()`, `integration_scop()`
  (the old SCP used `Standard_SCP` / `Integration_SCP`).

## Task → function cheat sheet

| Task | Functions |
|------|-----------|
| Cell QC / doublets / ambient RNA | `RunCellQC`, `RunDoubletCalling` (`db_scDblFinder`), `RunDecontX` |
| One-call standard pipeline (1 sample) | `standard_scop(srt)` → norm+HVG+PCA+UMAP+cluster |
| One-call integration (multi-sample) | `integration_scop(srt, batch="Sample", integration_method="Harmony")` |
| Annotation (reference-based) | `RunKNNPredict`, `RunSingleR`, `RunCellTypist` |
| UMAP / dim plots | `CellDimPlot`, `FeatureDimPlot`, `CellDensityPlot`, `ClusterTreePlot` |
| Cell composition / abundance | `CellStatPlot`; tests: `RunPropeller`, `RunscCODA`, `RunProportionTest` (+`ProportionTestPlot`) |
| Expression comparison (with stats) | `FeatureStatPlot` (violin/box/dot, built-in comparisons) |
| Grouped / dynamic heatmaps | `GroupHeatmap`, `FeatureHeatmap`, `DynamicHeatmap` |
| Differential expression | `RunDEtest(group_by=)`; plots `VolcanoPlot`, `DEtestPlot` |
| Enrichment | `RunEnrichment` (ORA), `RunGSEA`, `RunGSVA`; plots `EnrichmentPlot`, `GSEAPlot` |
| Trajectory / pseudotime | `RunSlingshot`, `RunMonocle3`, `RunCytoTRACE`, `RunDynamicFeatures`; plots `DynamicHeatmap`, `DynamicPlot`, `LineagePlot` |
| Gene regulatory network | `RunSCENIC` (+`SCENICPlot`) |

## Minimal end-to-end example

```r
library(scop)
save_plot <- function(p, f, w=7, h=6){ if(is.list(p)&&!inherits(p,"ggplot")&&!is.null(p$plot)) p<-p$plot
  ggplot2::ggsave(f, p, width=w, height=h, limitsize=FALSE) }

# If starting from a raw merged Seurat object with a "Sample" column:
srt <- RunCellQC(srt)
srt <- subset(srt, subset = CellQC == "Pass")
srt <- integration_scop(srt, batch = "Sample", integration_method = "Harmony")
# CellDimPlot will use the integrated reduction automatically (reduction = NULL)
save_plot(CellDimPlot(srt, group.by = c("Sample","seurat_clusters"), label = TRUE),
          "umap_clusters.pdf", w = 11)

# composition across a condition column "Group"
save_plot(CellStatPlot(srt, stat.by = "seurat_clusters", group.by = "Group",
                       plot_type = "bar", stat_type = "percent", position = "stack"),
          "composition.pdf")

# marker expression with significance
save_plot(FeatureStatPlot(srt, stat.by = c("CD14","FCGR3A"), group.by = "Group",
                          plot_type = "violin", add_box = TRUE,
                          multiplegroup_comparisons = TRUE),
          "markers.pdf", w = 8, h = 5)

# DE + enrichment (exploratory — see caution below)
srt <- RunDEtest(srt, group_by = "Group")
save_plot(VolcanoPlot(srt, group_by = "Group"), "volcano.pdf", w = 9, h = 7)
srt <- RunEnrichment(srt, group_by = "Group", db = "GO_BP", species = "Homo_sapiens")
save_plot(EnrichmentPlot(srt, group_by = "Group", plot_type = "bar"), "enrich.pdf", w = 9, h = 8)
```

More copy-paste recipes are in `reference/workflow.R`. The full function catalog (by category)
is in `reference/functions.md` — consult it before inventing a function name.

## Statistical caution (important)

- `RunDEtest` and SCOP's enrichment run at the **cell level** (cells treated as replicates). This
  is fine for exploration/figures but inflates significance when you only have a few biological
  samples. For group-level claims (e.g. disease vs control), use **pseudobulk** DE (aggregate by
  sample × cell type, then DESeq2/edgeR) and feed those gene lists into `RunEnrichment`/`RunGSEA`.
- For composition/abundance claims use `RunPropeller` or `RunscCODA`, not just the descriptive
  `CellStatPlot`.

## Pitfalls

- Wrong `reduction` name → empty/blank plot. Check `Reductions(srt)` first.
- Heatmap functions return a list; save `$plot`, not the list.
- `stat.by`/`features` must exist as a gene (rowname) or a meta.data column, else error.
- Enrichment/trajectory-enrichment need `species` set correctly.
- Don't call Python-backed functions (`RunSCVELO`, `RunPAGA`, scVI, CellTypist…) without running
  `PrepareEnv()` first; prefer R-native equivalents.
- When unsure of an argument, open the help: `?scop::FunctionName`.
