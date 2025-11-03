# Purpose: Interactive visNetwork of top-10 ranked LR pairs.

load(file.path(RESULTS_DIR, "08_lr_scored.rda"))
load(file.path(RESULTS_DIR, "01_anova.rda"))

top_pairs <- lr_scored |>
  filter((!is.na(ligand_q)  & ligand_q  < 0.05) |
         (!is.na(receptor_q) & receptor_q < 0.05)) |>
  slice_head(n = 10)

lr_edges <- top_pairs |> transmute(from = ligand, to = receptor)
lr_nodes <- tibble(id = unique(c(lr_edges$from, lr_edges$to)))

g_lr <- graph_from_data_frame(lr_edges, directed = FALSE, vertices = lr_nodes)
deg_lr <- degree(g_lr)

lr_nodes <- lr_nodes |>
  mutate(degree = deg_lr[match(id, names(deg_lr))]) |>
  left_join(anova_small, by = c("id" = "gene")) |>
  mutate(role = ifelse(id %in% lr_edges$from, "ligand",
                ifelse(id %in% lr_edges$to, "receptor", "other")))

vd <- toVisNetworkData(g_lr)
nodes <- vd$nodes |>
  left_join(lr_nodes, by = c("id" = "id")) |>
  mutate(
    size = 10 + 20 * (degree - min(degree, na.rm=TRUE)) / max(1, diff(range(degree, na.rm=TRUE))),
    title = paste0("<b>", label, "</b>",
                   "<br/>role: ", role,
                   "<br/>degree: ", degree,
                   "<br/>log2FC (DFU vs DFS): ", round(log2fc, 2))
  )
edges <- vd$edges

vn <- visNetwork(nodes, edges, width = "100%", height = "700px") |>
  visNodes(color = list(highlight = "gold")) |>
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) |>
  visLegend() |>
  visLayout(randomSeed = 1)

saveWidget(vn, file = OUT_LR_HTML, selfcontained = TRUE)
write.csv(top_pairs, OUT_LR_TOP10, row.names = FALSE)
