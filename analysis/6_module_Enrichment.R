# Purpose: Reactome enrichment per network module (top-N hub graph).

load(file.path(RESULTS_DIR, "05_g_top.rda"))

# modules
clu <- cluster_louvain(g_top)
mod_vec <- membership(clu)
mods <- split(names(mod_vec), mod_vec)
universe <- unique(unlist(mods))

# Reactome sets
msig <- msigdbr(species = "Homo sapiens", category = "C2", subcategory = "REACTOME") |>
  dplyr::select(gs_name, gene_symbol)
pathways <- split(msig$gene_symbol, msig$gs_name)

enrich_mod <- function(genes) {
  stats <- setNames(ifelse(universe %in% genes, 1, 0), universe)
  fgsea(pathways, stats, nperm = 10000) |>
    arrange(padj) |>
    head(10) |>
    transmute(pathway = pathway, NES = NES, padj = padj)
}

mod_enrich <- imap(mods, ~ enrich_mod(.x) |> mutate(module = .y)) |>
  bind_rows() |>
  dplyr::select(module, pathway, NES, padj)

write.csv(mod_enrich, OUT_MOD_ENRICH, row.names = FALSE)
