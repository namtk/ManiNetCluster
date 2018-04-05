#################################
### List All Genes in Modules ###
#################################
dayModules <- listModules(day_module_labels)
nightModules <- listModules(night_module_labels)

###########################################
### Calculate and Plot ModuleEigenGenes ###
###########################################
dayMEs = moduleEigengenes(dayExpr, colors = day_module_colors)$eigengenes

plot_MEs(dayMEs, day_module_colors)
plot_MEs_sep(dayMEs)

nightMEs = moduleEigengenes(nightExpr, colors = night_module_colors)$eigengenes

plot_MEs(nightMEs, night_module_colors)
plot_MEs_sep(nightMEs)

nightMEs1 <- nightMEs[-c(14,15),]
cormatMEs <- cor((dayMEs), (nightMEs1))

# scale data to mean=0, sd=1 and convert to matrix
cormatMEs_scaled <- as.matrix(scale(cormatMEs))

# create heatmap and don't reorder columns
heatmap(cormatMEs_scaled, Colv=F, scale='none', col=colorRampPalette(c("red","black","green"))(256))

library(reshape2)

cormatMEs_highPostive <- subset(melt(cormatMEs), value > .8)

cormatMEs_highPostive <- findSharedGenes(cormatMEs_highPostive)

cormatMEs_highNegative <- subset(melt(cormatMEs), value < -.8)

cormatMEs_highNegative <- findSharedGenes(cormatMEs_highNegative)

boxplot(cormatMEs, use.cols = T, horizontal = F, las=2)

########################################################################
### Plot Network Characteristics, ######################################
### i.e. Degree, Clustering Coefficient, Betweeness, EigenCentrality ###
### of the 2 networks ##################################################
library(igraph)

par(pty="s")
with(data.frame(
  node = colnames(datExpr), 
  day_degree = degree(dayGraph), 
  night_degree = degree(nightGraph)), 
  plot(
    day_degree, 
    night_degree, 
    col = kmeans(data.frame(
      node = colnames(datExpr), 
      day_degree = degree(dayGraph), 
      night_degree = degree(nightGraph))[, 2:3], 7, nstart = 20)$cluster))

par(pty="s")
with(data.frame(
  node = colnames(datExpr), 
  day_cc = transitivity(dayGraph, type = "local", isolates = "zero"), 
  night_cc = transitivity(nightGraph, type = "local", isolates = "zero")), 
  plot(
    day_cc, 
    night_cc, 
    col = kmeans(data.frame(
      node = colnames(datExpr), 
      day_cc = transitivity(dayGraph, type = "local", isolates = "zero"), 
      night_cc = transitivity(nightGraph, type = "local", isolates = "zero"))[, 2:3], 4, nstart = 20)$cluster))

par(pty="s")
with(data.frame(
  node = colnames(datExpr), 
  day_between = betweenness(dayGraph), 
  night_between = betweenness(nightGraph)), 
  plot(
    day_between, 
    night_between, 
    col = kmeans(data.frame(
      node = colnames(datExpr), 
      day_between = betweenness(dayGraph), 
      night_between = betweenness(nightGraph))[, 2:3], 4, nstart = 20)$cluster))

par(pty="s")
with(data.frame(
  node = colnames(datExpr), 
  day_eigen = eigen_centrality(dayGraph)$vector, 
  night_eigen = eigen_centrality(nightGraph)$vector), 
  plot(
    day_eigen, 
    night_eigen, 
    col = kmeans(data.frame(
      node = colnames(datExpr), 
      day_eigen = eigen_centrality(dayGraph)$vector, 
      night_eigen = eigen_centrality(nightGraph)$vector)[, 2:3], 4, nstart = 20)$cluster))

# library(igraph) 
# library(dplyr)
# 
# Coords <- layout_with_fr(dayGraph) %>% 
#   as_tibble %>%
#   bind_cols(data_frame(names = names(V(dayGraph))))
# 
# NetCoords <- data_frame(names = names(V(nightGraph))) %>%
#   left_join(Coords, by= "names")
# 
# dayGraph%>% 
#   plot(.,vertex.size=.001, edge.arrow.size=.4, vertex.label = NA)
# 
# nightGraph%>% 
#   plot(.,vertex.size=.001, edge.arrow.size=.4, vertex.label = NA)

###########################################################################################
### List all information (genes, ortho genes, modules labels/colors) for the 2 networks ###
###########################################################################################

# mani_modules_ortho <- merge(orthoData, mani_clust, by.x = 0, by.y = 1, all.y = TRUE)
# rownames(mani_modules_ortho) <- mani_modules_ortho$Row.names

day_modules_ortho <- merge(orthoData, day_module_colors, by = 0, all.x = TRUE)
rownames(day_modules_ortho) <- day_modules_ortho$Row.names
temp <- merge(day_modules_ortho, day_module_labels, by = 0, all.x = TRUE)
day_modules_ortho <- temp[, -c(2, 5)]

night_modules_ortho <- merge(orthoData, night_module_colors, by = 0, all.x = TRUE)
rownames(night_modules_ortho) <- night_modules_ortho$Row.names
temp <- merge(night_modules_ortho, night_module_labels, by = 0, all.x = TRUE)
night_modules_ortho <- temp[, -c(2, 5)]

write.csv(day_modules_ortho, file = 'output/day_modules_ortho.csv')
write.csv(night_modules_ortho, file = 'output/night_modules_ortho.csv')