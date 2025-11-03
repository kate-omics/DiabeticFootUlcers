# Purpose: Map HGNC symbols to Ensembl/UniProt via biomaRt.

load(file.path(RESULTS_DIR, "02_deg.rda"))

mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
map <- getBM(
  attributes = c("hgnc_symbol", "ensembl_gene_id", "uniprotswissprot"),
  filters    = "hgnc_symbol",
  values     = deg$`Gene Symbol`,
  mart       = mart
) |>
  distinct(hgnc_symbol, .keep_all = TRUE)

write.csv(map, file.path(RESULTS_DIR, "dfu_idmap_biomart.csv"), row.names = FALSE)
save(map, file = file.path(RESULTS_DIR, "03_map.rda"))
