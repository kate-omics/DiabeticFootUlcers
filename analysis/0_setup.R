# Purpose: Install/load packages and set global paths/params.

required <- c(
  "dplyr", "readxl", "biomaRt", "STRINGdb", "igraph",
  "visNetwork", "htmlwidgets", "msigdbr", "fgsea",
  "tidyr", "purrr", "OmnipathR"
)

# install if missing (comment out on HPC if restricted)
to_install <- required[!required %in% installed.packages()[, "Package"]]
if (length(to_install)) install.packages(to_install, repos="https://cloud.r-project.org")

# load
invisible(lapply(required, library, character.only = TRUE))

# ---- paths (edit as needed) ----
DATA_DIR   <- "DFU/data"
RESULTS_DIR<- "DFU/results"
dir.create(DATA_DIR,   showWarnings = FALSE, recursive = TRUE)
dir.create(RESULTS_DIR,showWarnings = FALSE, recursive = TRUE)

ANOVA_XLSX <- file.path(DATA_DIR, "GSE134431_diabetic_rna-seq_by_group.xlsx")

# STRING cache (local dir speeds up repeated calls)
STRING_CACHE <- "DFU/stringdb_cache"
dir.create(STRING_CACHE, showWarnings = FALSE, recursive = TRUE)

# network params
MIN_STRING_SCORE <- 700   # 700–900
TOP_N_HUBS       <- 100   # for hub subgraph (visualization)
STRICT_SCORE     <- 850   # for strict visualization/export

# output files
OUT_NET_HTML      <- file.path(RESULTS_DIR, "dfu_network_topHubs.html")
OUT_MOD_ENRICH    <- file.path(RESULTS_DIR, "dfu_modules_reactome_top10.csv")
OUT_LR_HTML       <- file.path(RESULTS_DIR, "dfu_top10_LR_network.html")
OUT_LR_PAIRS      <- file.path(RESULTS_DIR, "dfu_ligand_receptor_candidates.csv")
OUT_LR_RANKED     <- file.path(RESULTS_DIR, "dfu_ligrec_ranked.csv")
OUT_LR_TOP10      <- file.path(RESULTS_DIR, "dfu_top10_actionable_pairs.csv")
OUT_LR_REPORT     <- file.path(RESULTS_DIR, "dfu_top10_LR_report.csv")

# helper: safe numeric
num <- function(x) suppressWarnings(as.numeric(x))
