# Purpose: Filter DEGs by q-value & fold-change thresholds.

load(file.path(RESULTS_DIR, "01_anova.rda"))

deg <- anova |>
  filter(!is.na(`qvalue(p-value(DFU vs. DFS))`)) |>
  mutate(
    qvalue      = num(`qvalue(p-value(DFU vs. DFS))`),
    fold_change = num(`Fold-Change(DFU vs. DFS)`)
  ) |>
  filter(qvalue < 0.05, abs(fold_change) > 1.5)

message("DEG n = ", nrow(deg))
save(deg, file = file.path(RESULTS_DIR, "02_deg.rda"))
