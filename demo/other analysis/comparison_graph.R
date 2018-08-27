library(RcppCNPy)

linwarp <- npyLoad("data/kmedoids_linwarp.npy", "integer")

names(linwarp) <- c(names(day_module_labels), names(night_module_labels))
MncModules <- listModules(linwarp)
# dayModules
# nightModules

names(MncModules) <- paste0("MNC", 1:60)
names(dayModules) <- paste0("Day", 1:34)
names(nightModules) <- paste0("Night", 1:30)

nodes <- list()

for (i in 1:60) {
  nodes[[i]] <- MncModules[[i]]
}
for (i in 1:34) {
  nodes[[60+i]] <- dayModules[[i]]
}
for (i in 1:30) {
  nodes[[94+i]] <- nightModules[[i]]
}

names(nodes) <- c(names(MncModules), names(dayModules), names(nightModules))
nodes <- cbind(as.data.frame(names(nodes)), c(rep(1,60), rep(2,34), rep(3,30)))
nodes <- cbind(nodes, c(sapply(MncModules, function(x) length(x)),
                        sapply(dayModules, function(x) length(x)),
                        sapply(nightModules, function(x) length(x))))
colnames(nodes) <- c("id", "type", "size")

pair_nodes <- combn(nodes , 2 , simplify = FALSE)
sub_pairs <- expand.grid(names(MncModules), c(names(dayModules), names(nightModules)))
sub_pairs <- rbind(sub_pairs, expand.grid(names(dayModules), names(nightModules)))
out <- lapply(pair_nodes , function(x) length( intersect( x[[1]] , x[[2]] ) ) )

links <- as.data.frame(t(combn(names(nodes), 2)))
links$value <- unlist(out)

links$id <- paste(links$V1,links$V2)
sub_pairs$id <- paste(sub_pairs$Var1, sub_pairs$Var2)
links <- subset(links, id %in% sub_pairs$id)
links <- links[,-4]
links <- links[links$value != 0, ]

library(igraph)

# nodes <- as.data.frame(names(nodes))
# nodes$type <- c(rep(0,60), rep(1,124-60))

compare_graph <- graph_from_data_frame(d=links, vertices=nodes, directed=F)
# compare_bipartite <- make_bipartite_graph(as.integer(unlist(nodes$types)), links, directed = FALSE)
l <- layout_nicely(s1)

E(compare_graph)$weight <- links$value*.01 #unlist(links$value)
V(compare_graph)$size <- igraph::degree(compare_graph, mode="all")*0.1 #nodes$size*.005#
colrs <- c("#218a8cff", "#420051ff", "#fde623ff")
V(compare_graph)$color <- colrs[V(compare_graph)$type] #nodes$type
# V(compare_graph)$type <- 
s1 <- subgraph.edges(compare_graph, E(compare_graph)[E(compare_graph)$weight>1], del=F)
plot(s1, 
     # vertex.label = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, V(dayOrthoGraph)$name, NA),
     # vertex.label = V(dayOrthoGraph)$y.x,
     vertex.label = NA,
     # vertex.shape = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "square", "circle"),
     # vertex.frame.color = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "red", "black"),
     # vertex.label.cex = .5,
     # edge.color = ifelse(E(s1)$weight>300, "red", "black"),
     edge.width=E(s1)$weight,
     # edge.width=seq(1,10),
     layout=l)
