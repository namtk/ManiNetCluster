# https://mintgene.wordpress.com/2012/01/27/heatmaps-controlling-the-color-representation-with-set-data-range/

# gplots contains the heatmap.2 function
library(gplots)

# create 50x10 matrix of random values from [-1, +1]
random.matrix  <- matrix(runif(500, min = -1, max = 1), nrow = 50)

# following code limits the lowest and highest color to 5%, and 95% of your range, respectively
quantile.range <- quantile(random.matrix, probs = seq(0, 1, 0.01))
palette.breaks <- seq(quantile.range["5%"], quantile.range["95%"], 0.1)

# use http://colorbrewer2.org/ to find optimal divergent color palette (or set own)
color.palette  <- colorRampPalette(c("#deebf7", "#9ecae1", "#3182bd"))(length(palette.breaks) - 1)

heatmap.2(
  
  random.matrix,
  
  dendrogram = "none",
  scale      = "none",
  trace      = "none",
  key        = FALSE,
  labRow     = NA,
  labCol     = NA,
  
  col    = color.palette,
  breaks = palette.breaks,
  lmat = matrix(c(4,2,3,1),
                nrow=2,
                ncol=2),
  lhei = c(0.1,0.9),
  lwid = c(0.3,0.7)
)
