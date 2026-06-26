# SCOP function catalog (mengxu98/scop)

Grouped reference of the package's functions. Use this to pick the correct function name and
avoid hallucinating APIs. When you need exact arguments, run `?scop::FunctionName` in R.

## Standard pipelines (lowercase in this fork)
- `standard_scop(srt)` — full single-sample pipeline: Normalize → HVG → Scale → PCA → UMAP → cluster.
- `integration_scop(srt, batch, integration_method)` — multi-sample integration pipeline.
  `integration_method` ∈ Uncorrected, Seurat, CCA, RPCA, fastMNN, Harmony, MNN, Scanorama, BBKNN,
  CSS, LIGER, scVI, Conos, ComBat, WNN (… `*_integrate()` are the underlying functions).

## Quality control
`RunCellQC`, `RunSpotQC`, `RunATACQC`, `RunDoubletCalling`, `db_scDblFinder`, `db_scds`,
`db_Scrublet`, `db_DoubletDetection`, `RunDecontX` (ambient RNA), `RunCellCycle`, `CycGenePrefetch`.

## Dim reduction & clustering
`NormalizeData`, `FindVariableFeatures`, `ScaleData`, `SCTransform`, `RunPCA`, `RunUMAP`,
`FindNeighbors`, `RunDimsEstimate`, `RunDimsReduction`, plus alternatives: `RunDM`, `RunNMF`,
`RunMDS`, `RunGLMPCA`, `RunPaCMAP`, `RunTriMap`, `RunPHATE`, `RunLargeVis`, `RunFR`.

## Annotation
`RunKNNPredict`, `RunKNNMap`, `RunSingleR`, `RunCellTypist` (py), `RunScmap`, `RunSciBet`,
`RunLabelTransfer`, `RunReferenceMapping`, `RunCoEmbedding`, `CellTypistModels`, `TrainCellTypist`.

## Differential expression & perturbation
`RunDEtest`, `FindMarkers`, `FindAllMarkers`, `FindExpressedMarkers`, `FoldChange`, `RunAugur`,
`RunScissor`, `RunRareQ`, `RunscTenifoldNet`, `RunscTenifoldKnk`.

## Composition / differential abundance
`RunPropeller`, `RunscCODA`, `RunProportionTest`, `RunPermutation`, `RunMilo`.

## Enrichment
`RunEnrichment` (ORA), `RunGSEA`, `RunGSVA`, `RunDynamicEnrichment`, `CellScoring`,
`RunMetabolism`, `RunDorothea`. Common args: `group_by`, `db` (e.g. "GO_BP","GO_CC","GO_MF","KEGG",
"Reactome","WikiPathway","MSigDB"), `species`, `DE_threshold`.

## Trajectory / pseudotime
`RunSlingshot`, `RunMonocle3`, `RunMonocle2`, `RunCytoTRACE`, `RunPalantir` (py), `RunPAGA` (py),
`RunCellRank` (py), `RunWOT`, `RunSCVELO` (py), `RunDynamicFeatures`.

## Gene regulatory networks
`RunSCENIC`, `RunSCENICPlus` (py), `RunGENIE3`, `RunGRNBoost2`, `RunCisTarget`.

## Cell-cell communication
`RunCCC`, `RunCellChat`, `RunCellphoneDB`, `RunLIANA`, `RunNichenetr`, `RunMultiNichenetr`.

## Visualization — by category
- **Dim/feature:** `CellDimPlot`, `CellDimPlot3D`, `FeatureDimPlot`, `FeatureDimPlot3D`,
  `CellDensityPlot`, `ClusterTreePlot`, `DimsEstimatePlot`, `ProjectionPlot`.
- **Stat/expression:** `CellStatPlot`, `FeatureStatPlot`, `FeatureCorPlot`, `CellCorHeatmap`,
  `FeatureHeatmap`, `GroupHeatmap`.
- **DE:** `VolcanoPlot`, `DEtestPlot`, `DEtestManhattanPlot`, `DEtestRingPlot`.
- **Enrichment:** `EnrichmentPlot`, `GSEAPlot`, `GSVAPlot`, `FerrisWheelPlot`, `DorotheaPlot`.
- **Trajectory:** `DynamicHeatmap`, `DynamicPlot`, `LineagePlot`, `CytoTRACEPlot`,
  `PseudotimeProjectionPlot`, `BranchStreamPlot`, `PAGAPlot`, `VelocityPlot`.
- **GRN/CCC:** `SCENICPlot`, `CCCHeatmap`, `CCCNetworkPlot`, `CCCStatPlot`.
- **Composition:** `ProportionTestPlot`.

## Key plot signatures (verified)

```r
CellDimPlot(srt, group.by, reduction = NULL, split.by = NULL, label = FALSE,
            theme_use = "theme_scop", palette = "Chinese", ncol = NULL, ...)

FeatureDimPlot(srt, features, reduction = NULL, split.by = NULL, ncol = NULL, ...)

CellStatPlot(srt, stat.by, group.by = NULL, split.by = NULL,
             plot_type = c("bar","rose","ring","pie","trend","trend_alluvial","area",
                           "dot","sankey","chord","venn","upset"),
             stat_type = c("percent","count"), position = c("stack","dodge"),
             label = FALSE, flip = FALSE, palette = "Chinese", ...)

FeatureStatPlot(srt, stat.by, group.by = NULL, split.by = NULL,
                plot_type = c("violin","box","bar","dot","col"),
                add_box = FALSE, add_point = FALSE, comparisons = NULL,
                multiplegroup_comparisons = FALSE, palette = "Chinese", ...)

GroupHeatmap(srt, features = NULL, group.by = NULL, split.by = NULL,
             cell_annotation = NULL, feature_annotation = NULL,
             heatmap_palette = "RdBu", nlabel = 20, show_row_names = FALSE, ...)  # returns list, use $plot

DynamicHeatmap(srt, lineages, use_fitted = TRUE, n_split = NULL,
               species = "Homo_sapiens", db = "GO_BP", show_row_names = FALSE, ...)  # returns list, use $plot
```

## Data conversion (interop with Scanpy/loom)
`srt_to_adata`, `adata_to_srt`, `srt_to_h5ad`, `h5ad_to_srt`, `loom_to_srt`, `loom_to_adata`.

## Utilities
`DefaultReduction`, `RenameClusters`, `RenameFeatures`, `GeneConvert`, `ConvertHomologs`,
`srt_append`, `srt_reorder`, `RunSCExplorer` (interactive Shiny browser).
