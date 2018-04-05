# Choose the soft-thresholding power: analysis of network topology
# Manually look at the plot to choose soft threshold for both "day" and "night" network

# Choose a set of soft-thresholding powers
powers = c(c(1:10), seq(from = 20, to=100, by=10))

# Call the network topology analysis function: uncomment 1 of 2 lines below to pick soft threshold for "day" or "night" network
# sft = pickSoftThreshold(dayExpr, powerVector = powers, verbose = 5)   # for "day" network
# sft = pickSoftThreshold(nightExpr, powerVector = powers, verbose = 5) # for "night" network

# Plot the results:
sizeGrWindow(9, 5)
par(mfrow = c(1,2));
cex1 = 0.9;
# Scale-free topology fit index as a function of the soft-thresholding power
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.90,col="red")
# Mean connectivity as a function of the soft-thresholding power
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")

# Construct the gene network and identifying modules
dayNet = blockwiseModules(dayExpr, power = 7,
                       TOMType = "unsigned", minModuleSize = 30,
                       reassignThreshold = 0, mergeCutHeight = 0.25,
                       numericLabels = TRUE, pamRespectsDendro = FALSE,
                       saveTOMs = TRUE,
                       saveTOMFileBase = "./output/dayTOM", 
                       verbose = 3);
nightNet = blockwiseModules(nightExpr, power = 20,
                          TOMType = "unsigned", minModuleSize = 30,
                          reassignThreshold = 0, mergeCutHeight = 0.25,
                          numericLabels = TRUE, pamRespectsDendro = FALSE,
                          saveTOMs = TRUE,
                          saveTOMFileBase = "./output/nightTOM", 
                          verbose = 3);

# Display The dendrogram together with the color assignment

# for "day" network
plot_dendro(dayNet)

# for "night" network
plot_dendro(nightNet)
