# Purpose: Tabular LR “action suggestions” (agonize vs antagonize) with scores.

load(file.path(RESULTS_DIR, "08_lr_scored.rda"))

lr_actions <- lr_scored |>
  mutate(
    dir_lig = case_when(ligand_log2fc  >  0.5 ~ "up",
                        ligand_log2fc  < -0.5 ~ "down",
                        TRUE ~ "flat"),
    dir_rec = case_when(receptor_log2fc >  0.5 ~ "up",
                        receptor_log2fc < -0.5 ~ "down",
                        TRUE ~ "flat"),
    suggested_action = case_when(
      dir_lig == "up" | dir_rec == "up"   ~ "antagonize/block",
      dir_lig == "down" | dir_rec == "down" ~ "agonize/mimic",
      TRUE ~ "review/context"
    )
  )

report <- lr_actions |>
  transmute(
    ligand, receptor,
    ligand_log2fc  = round(ligand_log2fc, 2),
    receptor_log2fc= round(receptor_log2fc, 2),
    ligand_q       = signif(ligand_q, 3),
    receptor_q     = signif(receptor_q, 3),
    net_score      = round(net_score, 1),
    dys_score      = round(dys_score, 1),
    rank_score     = round(rank_score, 1),
    suggested_action
  ) |>
  slice_head(n = 10)

write.csv(report, OUT_LR_REPORT, row.names = FALSE)
