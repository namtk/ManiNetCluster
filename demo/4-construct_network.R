############################################################################
### Construct Networks (Module Labels/Colors) for both "Day" and "Night" ###
############################################################################

# day_adj_mat <- matrix(, nrow = nGenes, ncol = nGenes)
day_module_labels <- cordist_netConstruct(dayExpr, 20)
names(day_module_labels) <- colnames(dayExpr)

# assign a color to each module for easier visualization and referencing
day_module_colors <- WGCNA::labels2colors(day_module_labels)
names(day_module_colors) <- colnames(dayExpr)

# night_adj_mat <- matrix(, nrow = nGenes, ncol = nGenes)
night_module_labels <- cordist_netConstruct(nightExpr, 20)
names(night_module_labels) <- colnames(nightExpr)

# assign a color to each module for easier visualization and referencing
night_module_colors <- labels2colors(night_module_labels)
names(night_module_colors) <- colnames(nightExpr)