library(WGCNA)

# Check for genes and samples with too many missing values
gsg = goodSamplesGenes(datExpr0, verbose = 3);
gsg$allOK

if (!gsg$allOK)
{
  # Optionally, print the gene and sample names that were removed:
  if (sum(!gsg$goodGenes)>0) 
    printFlush(paste("Removing genes:", paste(names(datExpr0)[!gsg$goodGenes], collapse = ", ")));
  if (sum(!gsg$goodSamples)>0) 
    printFlush(paste("Removing samples:", paste(rownames(datExpr0)[!gsg$goodSamples], collapse = ", ")));
  # Remove the offending genes and samples from the data:
  datExpr0 = datExpr0[gsg$goodSamples, gsg$goodGenes]
}

# Cluster the samples to see if there are any obvious outliers
sampleTree = hclust(dist(datExpr0), method = "average");
# Plot the sample tree: Open a graphic output window of size 12 by 9 inches
# The user should change the dimensions if the window is too large or too small.
sizeGrWindow(12,9)
# pdf(file = "figs/sampleClustering.pdf", width = 12, height = 9);
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5, 
     cex.axis = 1.5, cex.main = 2)

# Check sample using a sample-correlation heatmap
nSamples = nrow(datExpr0)

library('RColorBrewer')
library('gplots')

sampleColors <- colorRampPalette(brewer.pal(nSamples, "Set1"))(nSamples)

heatmap.2(cor(t(datExpr0)), RowSideColors = sampleColors,
          trace='none', main='Sample correlations (raw)')

# Filter Low Count: Remove all rows with less than 1 counts across all samples.
# 1 is an arbitrary value and low count filtering for RNA-Seq data should be done more precisely using some probabilistic approach, e.g.
# a density plot of RPKM which leads to a decision of cutoff value.
low_count_mask <- colSums(datExpr0) < 1

sprintf("Removing %d low-count genes (%d remaining).", sum(low_count_mask), 
        sum(!low_count_mask))

# Log2 Transformation:
# 
# Most of the methods developed for co-expression network analysis and network inference were written for use with microarray data, including WGCNA!
# Attempting to apply a method such as this to discrete-count RNA-Seq data will not work out well.
# There are a number of methods for working around this, in effect, making RNA-Seq data "look" more like microarray data, but the simplest thing is just to log the data. This will transform our discrete, over-dispersed counts to a more Poisson-like continuous distribution.
datExpr <- t(log2(t(datExpr0) + 1))

# Let's see how things look after logging the data.
library(reshape2)
library(ggplot2)

x = melt(as.matrix(t(datExpr)))

colnames(x) = c('gene_id', 'sample', 'value')
ggplot(x, aes(x=value, color=sample)) + geom_density()

heatmap.2(cor(t(datExpr)), RowSideColors=sampleColors,
          trace='none', main='Sample correlations (log2-transformed)')


# Remove genes with _zero_ variance
getVar <- apply(datExpr0, 2, var)
param <- 1e-4
datExpr <- datExpr[, getVar > param & !is.na(getVar)]

nGenes = ncol(datExpr)

# divide data into "day" and "night" data
dayExpr = (datExpr[1:13, ] + datExpr[29:41, ]) / 2;
write.csv(dayExpr, file = "./output/dayExpr.csv");
nightExpr = (datExpr[14:28, ] + datExpr[42:56, ]) / 2;
write.csv(nightExpr, file = "./output/nightExpr.csv")