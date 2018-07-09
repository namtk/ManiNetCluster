library(sna); library(igraph); library(intergraph)

g <- asNetwork(s1)
triads1 <- combn(1:network.size(g),3, simplify = F)
triad_census <- lapply(1:length(triads1), 
                       function(x) triad.classify(g,tri=triads1[[x]]))
triads1 <- data.frame(matrix(unlist(triads1), nrow=length(triads1), byrow=T),
                     triad = unlist(triad_census))
triads1 <- triads1[which(triads1$triad == "300" | triads1$triad == "201"), ]

triads1[,1:3] <- sapply(triads1[,1:3], function(x) vertex_attr(compare_graph)$name[x])

triads1 <- triads1[(grepl("MNC", triads1$X1) & grepl("Day", triads1$X2) & grepl("Night", triads1$X3)) |
  (grepl("MNC", triads1$X1) & grepl("Night", triads1$X2) & grepl("Day", triads1$X3)) |
  (grepl("Day", triads1$X1) & grepl("MNC", triads1$X2) & grepl("Night", triads1$X3)) |
  (grepl("Day", triads1$X1) & grepl("Night", triads1$X2) & grepl("MNC", triads1$X3)) |
  (grepl("Night", triads1$X1) & grepl("MNC", triads1$X2) & grepl("Day", triads1$X3)) |
  (grepl("Night", triads1$X1) & grepl("Day", triads1$X2) & grepl("MNC", triads1$X3)),]

# triads
# triads[triads$triad == 201, ]
# triads[triads$triad == 300, ]
# triads1