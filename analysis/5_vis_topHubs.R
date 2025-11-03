# Purpose: Make an interactive visNetwork plot for top-N hubs.

load(file.path(RESULTS_DIR, "04_string_net.rda"))

deg_all  <- degree(g)
top_nodes <- names(sort(deg_all, decreasing = TRUE))[seq_len(min(TOP_N_HUBS, vcount(g)))]
g_top    <- induced_subgraph(g, vids = top_nodes)

clu <- cluster_louvain(g_top)
V(g_top)$module <- as.integer(membership(clu))
V(g_top)$degree <- as.numeric(degree(g_top))
V(g_top)$label  <- V(g_top)$name

vd <- toVisNetworkData(g_top)
nodes <- vd$nodes; edges <- vd$edges

nodes$degree <- V(g_top)$degree[match(nodes$id, names(V(g_top)))]
nodes$module <- V(g_top)$module[match(nodes$id, names(V(g_top)))]
# size by degree (5–35)
s <- nodes$degree
s <- 5 + 30 * (s - min(s, na.rm=TRUE)) / max(1, diff(range(s, na.rm=TRUE)))
nodes$size  <- s
nodes$group <- as.character(nodes$module)
nodes$title <- paste0("<b>", nodes$label, "</b>",
                      "<br/>degree: ", nodes$degree,
                      "<br/>module: ", nodes$group)

vn <- visNetwork(nodes, edges, width = "100%", height = "850px") |>
  visOptions(highlightNearest = list(enabled = TRUE, degree = 1),
             nodesIdSelection = TRUE) |>
  visLegend() |>
  visPhysics(stabilization = list(iterations = 600)) |>
  visLayout(randomSeed = 1)

saveWidget(vn, file = OUT_NET_HTML, selfcontained = TRUE)
save(g_top, file = file.path(RESULTS_DIR, "05_g_top.rda"))
