# Purpose: Load ligand–receptor pairs from Omnipath.

# Try modern api; fallback to legacy.
lrdb <- tryCatch({
  intercell_network(scope = "ligand_receptor") |>
    dplyr::select(source_genesymbol, target_genesymbol) |>
    distinct()
}, error = function(e) {
  message("Fallback to older function...")
  import_LigRecExtra_omnipath() |>
    dplyr::select(source_genesymbol, target_genesymbol) |>
    distinct()
})

write.csv(lrdb, file.path(RESULTS_DIR, "dfu_lrdb_omnipath.csv"), row.names = FALSE)
save(lrdb, file = file.path(RESULTS_DIR, "07_lrdb.rda"))
