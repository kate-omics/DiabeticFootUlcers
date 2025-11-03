# Purpose: Load ANOVA sheet and normalize column names.

anova <- read_excel(ANOVA_XLSX, skip = 1)

# Expect these columns in the sheet - first analysis - DFU vs DFS , next triple analysis
stopifnot(all(c("Gene Symbol", "Fold-Change(DFU vs. DFS)", "qvalue(p-value(DFU vs. DFS))") %in% names(anova)))

# Small tidy table for later joins
anova_small <- anova |>
  dplyr::transmute(
    gene   = `Gene Symbol`,
    log2fc = num(`Fold-Change(DFU vs. DFS)`),
    q      = num(`qvalue(p-value(DFU vs. DFS))`)
  )
save(anova, anova_small, file = file.path(RESULTS_DIR, "01_anova.rda"))
