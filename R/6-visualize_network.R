#############################################################
### Export Networks to GraphML for both "Day" and "Night" ###
#############################################################
day_adj_mat <- readRDS(file = "output/dayExpr_mat.rds")
dayGraph <- export_network_to_graphml(day_adj_mat, filename="output/dayGraph.graphml",
                                      threshold = 0.4)

night_adj_mat <- readRDS(file = "output/nightExpr_mat.rds")
nightGraph <- export_network_to_graphml(night_adj_mat, filename = "output/nightGraph.graphml",
                                        threshold = 0.4)

#########################################################
### Visualize Networks for Genes which Have Orthologs ###
#########################################################
# day_adj_mat[day_modules_ortho$Row.names, day_modules_ortho$Row.names]
dayOrtho_adj_mat <- day_adj_mat[day_modules_ortho$Row.names, day_modules_ortho$Row.names]
nightOrtho_adj_mat <- night_adj_mat[night_modules_ortho$Row.names, night_modules_ortho$Row.names]

night_links <- melt(nightOrtho_adj_mat)
nightOrthoGraph <- graph_from_data_frame(d=night_links, vertices=night_modules_ortho, directed=F)
nightOrthoGraph <- simplify(nightOrthoGraph, remove.loops = TRUE)

day_links <- melt(dayOrtho_adj_mat)
dayOrthoGraph <- graph_from_data_frame(d=day_links, vertices=day_modules_ortho, directed=F)
dayOrthoGraph <- simplify(dayOrthoGraph, remove.loops = TRUE)

dayGraphOrtho <- export_network_to_graphml(dayOrtho_adj_mat, filename="output/dayGraphOrtho.graphml",
                                      threshold = 0.25)

nightGraphOrtho <- export_network_to_graphml(nightOrtho_adj_mat, filename="output/nightGraphOrtho.graphml",
                                             threshold = 0.25)

# iso <- V(dayGraphOrtho)[degree(dayGraphOrtho)==0]
# g2 <- delete.vertices(dayGraphOrtho, iso)

l <- layout_with_fr(dayGraphOrtho)
l2 <- layout_with_fr(nightGraphOrtho)

# V(dayGraphOrtho)$color <- adjustcolor(V(dayOrthoGraph)$y.x, alpha.f = .5)
V(dayGraphOrtho)$color <- adjustcolor(V(nightOrthoGraph)$y.x, alpha.f = .5)
V(dayGraphOrtho)$size <- degree(dayGraphOrtho, mode="all")

V(nightGraphOrtho)$color <- adjustcolor(V(nightOrthoGraph)$y.x, alpha.f = .5)
# V(nightGraphOrtho)$color <- adjustcolor(V(dayOrthoGraph)$y.x, alpha.f = .5)
V(nightGraphOrtho)$size <- degree(nightGraphOrtho, mode="all")

# V(dayGraphOrtho)$community <- V(dayOrthoGraph)$y.y
# V(nightGraphOrtho)$community <- V(nightOrthoGraph)$y.y

plot(dayGraphOrtho, 
     # vertex.label = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, V(dayOrthoGraph)$name, NA),
     # vertex.label = V(dayOrthoGraph)$y.x,
     vertex.label = NA,
     # vertex.shape = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "square", "circle"),
     # vertex.frame.color = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "red", "black"),
     vertex.label.cex = .5,
     layout=l)
plot(1, type="n", axes=FALSE, xlab="", ylab="")
legend("topright", title="Module Functions",
       c("protein binding, thiol-dependent\nubiquitin-specific protease activity",
         "threonine-type endopeptidase\nactivity",
         "catalytic activity, 3-methyl-2-oxobutanoate\ndehydrogenase (2-methylpropanoyl-transferring) activity",
         "structural constituent of ribosome"), 
       fill=c("turquoise",
              "magenta",
              "blue",
              "darkolivegreen"), horiz=FALSE, cex=0.5,
       y.intersp=1.6
       )

plot(nightGraphOrtho, 
     # vertex.label=ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, V(dayOrthoGraph)$name, NA),
     # vertex.label=V(nightOrthoGraph)$y.x,
     vertex.label = NA,
     # vertex.shape = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "square", "circle"),
     vertex.frame.color = ifelse(V(dayOrthoGraph)$y.x == "turquoise" & degree(dayGraphOrtho) > 12, "red", "black"),
     layout=l2,
     # mark.groups=list(V(nightOrthoGraph)[V(nightOrthoGraph)$y.x == "turquoise" & degree(nightGraphOrtho) > 10]$name,
     #                  V(nightOrthoGraph)[V(nightOrthoGraph)$y.x == "brown" & degree(nightGraphOrtho) > 7]$name),
     # mark.col=adjustcolor(c("turquoise","brown"), alpha.f = .4), mark.border=NA
     )
plot(1, type="n", axes=FALSE, xlab="", ylab="")
legend("top", title="Module Functions",
       c("threonine-type endopeptidase\nactivity",
         "catalytic activity, queuine\ntRNA-ribosyltransferase activity"), 
       fill=c("turquoise",
              "brown"), horiz=FALSE, cex=0.5,
       # y.intersp=1.6
)
# colrs <- adjustcolor(V(dayOrthoGraph)$y.x, alpha=.6)
# plot(dayGraphOrtho, vertex.color=colrs)
