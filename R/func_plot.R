# Display The dendrogram together with the color assignment
#' @param 
#' @return 
#' @export 
plot_dendro <- function(net) {
  # open a graphics window
  sizeGrWindow(12, 9)
  # Convert labels to colors for plotting
  mergedColors = labels2colors(net$colors)
  # Plot the dendrogram and the module colors underneath
  pdf(file = paste("figs/", deparse(substitute(net)), "_dendro_plot.pdf", sep = ""))
  
  plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                      "Module colors",
                      dendroLabels = FALSE, hang = 0.03,
                      addGuide = TRUE, guideHang = 0.05)
  
  dev.off()
}

#' @param 
#' @return 
#' @export 
plot_MEs <- function(MEs, module_colors) {
  colors <- rownames(table(module_colors))
  
  # pdf(file = paste("figs/", deparse(substitute(MEs)), "_plot.pdf", sep = ""))
  
  # invisible(sapply(
  #   seq_along(MEs), function(i) {
  #     plot(MEs[[i]], type = 'l', col = colors[i], ylim = c(-0.6,1.0), xlab = '', ylab = '');
  #     par(new=TRUE)
  #   }
  # ))
  
  # numPlots = length(MEs)
  # for (i in 1:numPlots) {
  #   plot(MEs[[i]], type = 'l', col = colors[i], ylim = c(-0.6,1.0), xlab = '', ylab = '')
  #   par(new=TRUE)}
  
  # dev.off()
  
  MEs_melted <- melt(cbind(time = as.numeric(rownames(MEs)), MEs), id = "time")
  ggplot(MEs_melted, aes(time, value)) + geom_line(aes(colour = variable)) +
    scale_colour_manual(values = colors) + xlab("time points") + ylab("expression level") +
    theme_bw() + guides(colour=FALSE)
  
  ggsave(paste("figs/", deparse(substitute(MEs)), "_plot.pdf", sep = ""))
}

#' @param 
#' @return 
#' @export 
plot_MEs_sep <- function(MEs) {
  numPlots = length(MEs)
  fpath <- file.path("figs", deparse(substitute(MEs)))
  if (! dir.exists(fpath)) dir.create(fpath)
  # setwd(fpath)
  
  for (i in 1:numPlots) {
    fname <- file.path(fpath, paste(names(MEs)[i], "_plot.pdf", sep = ""))
    pdf(file = fname)
    plot(MEs[[i]], type = 'l', col = "green", ylim = c(-0.6,1.0), xlab = '', ylab = '')
    dev.off()
  }
  # setwd("~/PlantWGCNA")
}