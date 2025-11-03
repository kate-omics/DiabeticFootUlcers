# Purpose: One-click orchestrator.

source("DFU/analysis/00_setup.R")
source("DFU/analysis/01_load_anova.R")
source("DFU/analysis/02_filter_deg.R")
source("DFU/analysis/03_map_ids_biomart.R")
source("DFU/analysis/04_string_network.R")
source("DFU/analysis/05_vis_top_hubs.R")
source("DFU/analysis/06_module_enrichment.R")
source("DFU/analysis/07_omnipath_lr_load.R")
source("DFU/analysis/08_rank_lr_pairs.R")
source("DFU/analysis/09_vis_lr_pairs.R")
source("DFU/analysis/10_lr_report.R")

message("Pipeline complete.")
