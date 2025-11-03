# Purpose: Build STRING network within the DEG set and compute hubs.

load(file.path(RESULTS_DIR, "03_map.rda"))

string_db <- STRINGdb$new(version = "12.0", species = 9606,
                          score_threshold = 400, input_directory = STRING_CACHE)

mapped <- string_db$map(map, "hgnc_symbol", removeUnmappedRows = TRUE) |>
  distinct(hgnc_symbol, .keep_all = TRUE)

hits_all <- string_db$get_interactions(mapped$STRING_id)

keep_ids <- mapped$STRING_id
hits <- hits_all |>
  filter(from %in% keep_ids & to %in% keep_ids,
         combined_score >= MIN_STRING_SCORE) |>
  distinct(from, to, .keep_all = TRUE)

id2sym <- mapped |>
  dplyr::select(STRING_id, gene_symbol = hgnc_symbol)

edges_sym <- hits |>
  left_join(id2sym, by = c("from" = "STRING_id")) |>
  rename(from_sym = gene_symbol) |>
  left_join(id2sym, by = c("to" = "STRING_id")) |>
  rename(to_sym = gene_symbol) |>
  dplyr::select(from_sym, to_sym, combined_score, dplyr::everything())

g <- graph_from_data_frame(edges_sym[, c("from_sym", "to_sym")], directed = FALSE) |>
  simplify(remove.multiple = TRUE, remove.loops = TRUE)

hub_tbl <- tibble(
  gene       = V(g)$name,
  degree     = degree(g),
  betweenness= betweenness(g, directed = FALSE, normalized = TRUE)
) |> arrange(desc(degree))

write.csv(edges_sym, file.path(RESULTS_DIR, "dfu_string_interactions_inset_sym.csv"), row.names = FALSE)
write.csv(hub_tbl,  file.path(RESULTS_DIR, "dfu_string_hubs.csv"), row.names = FALSE)

save(edges_sym, g, hub_tbl, file = file.path(RESULTS_DIR, "04_string_net.rda"))
