# Purpose: Rank LR pairs found inside the top-hub network using centrality + dysregulation.

load(file.path(RESULTS_DIR, "05_g_top.rda"))
load(file.path(RESULTS_DIR, "01_anova.rda"))
load(file.path(RESULTS_DIR, "07_lrdb.rda"))

genes_top <- V(g_top)$name

lr_in_net <- lrdb |>
  rename(ligand = source_genesymbol, receptor = target_genesymbol) |>
  filter(ligand %in% genes_top & receptor %in% genes_top)

# degree-based network score
deg_tbl <- tibble(gene = genes_top, degree = degree(g_top))

score_lr <- lr_in_net |>
  left_join(deg_tbl, by = c("ligand" = "gene"))  |> rename(deg_ligand = degree) |>
  left_join(deg_tbl, by = c("receptor" = "gene"))|> rename(deg_receptor = degree) |>
  mutate(net_score = coalesce(deg_ligand, 0) + coalesce(deg_receptor, 0))

# add dysregulation
lr_scored <- score_lr |>
  left_join(anova_small, by = c("ligand" = "gene"))   |> rename(ligand_log2fc = log2fc, ligand_q = q) |>
  left_join(anova_small, by = c("receptor" = "gene")) |> rename(receptor_log2fc = log2fc, receptor_q = q) |>
  mutate(
    dys_score  = abs(coalesce(ligand_log2fc, 0)) + abs(coalesce(receptor_log2fc, 0)),
    rank_score = net_score + 2 * dys_score
  ) |>
  arrange(desc(rank_score))

write.csv(score_lr,   OUT_LR_PAIRS,  row.names = FALSE)
write.csv(lr_scored,  OUT_LR_RANKED, row.names = FALSE)
save(lr_scored, file = file.path(RESULTS_DIR, "08_lr_scored.rda"))
