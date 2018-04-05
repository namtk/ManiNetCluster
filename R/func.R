#'
#' Similarity measure which combines elements from Pearson correlation and
#' Euclidean distance.
#' 
#' Note that: dat is a data matrix with observations as columns (samples) and features as rows (genes)
cordist <- function(dat) {
  cor_matrix  <- cor(t(dat))
  
  dist_matrix <- as.matrix(dist(dat, diag=TRUE, upper=TRUE))
  dist_matrix <- log1p(dist_matrix)
  dist_matrix <- 1 - (dist_matrix / max(dist_matrix))
  
  sign(cor_matrix) * ((abs(cor_matrix) + dist_matrix)/ 2)
}


cordist_netConstruct <- function(dat, powr) {
  # Construct similarity matrix using cordist function (combination of both Pearson correlation and Euclidian distance)
  sim_matrix <- cordist(t(dat))
  gc()
  
  # Let's see what our similarity matrix looks like at this point.
  # Because the heatmap.2 function (which includes a biclustering step) can be pretty slow, we will use a sub-sample of our data.
  # For visualization purposes, this is fine.
  pdf(file = paste("figs/", deparse(substitute(dat)), "_sim_matrix.pdf", sep = ""))
  
  heatmap_indices <- sample(nrow(sim_matrix), 500)
  
  heatmap.2(t(sim_matrix[heatmap_indices, heatmap_indices]),
            col=redgreen(75),
            labRow=NA, labCol=NA, 
            trace='none', dendrogram='row',
            xlab='Gene', ylab='Gene',
            main='Similarity matrix',
            density.info='none', revC=TRUE)
  
  dev.off()
  
  # Construct adjacency matrix
  adj_matrix <- adjacency.fromSimilarity(sim_matrix, power=powr, type='signed')
  
  # Delete similarity matrix to free up memory
  rm(sim_matrix)
  gc()
  
  # Convert to matrix
  gene_ids <- rownames(adj_matrix)
  
  adj_matrix <- matrix(adj_matrix, nrow=nrow(adj_matrix))
  rownames(adj_matrix) <- gene_ids
  colnames(adj_matrix) <- gene_ids
  saveRDS(adj_matrix, file = paste("output/", deparse(substitute(dat)), "_mat.rds", sep = ""))
  
  # Same plot as before, but now for our adjacency matrix:
  pdf(file = paste("figs/", deparse(substitute(dat)), "_adj_matrix.pdf", sep = ""))

  heatmap.2(t(adj_matrix[heatmap_indices, heatmap_indices]),
            col=redgreen(75),
            labRow=NA, labCol=NA,
            trace='none', dendrogram='row',
            xlab='Gene', ylab='Gene',
            main='Adjacency matrix',
            density.info='none', revC=TRUE)

  dev.off()
  
  TOM = TOMsimilarity(adj_matrix);
  dissTOM = 1-TOM
  rownames(dissTOM) <- gene_ids
  colnames(dissTOM) <- gene_ids
  saveRDS(dissTOM, file = paste("output/", deparse(substitute(dat)), "_TOM.rds", sep = ""))
  
  # Detect Co-expression Modules:
  
  # Cluster gene expression profiles; the flashClust function from
  # the authors of WGCNA is another options for larger datasets.
  # For input, we use the reciprocal of the adjacency matrix; hierarchical
  # clustering works by comparing the _distance_ between objects instead of the
  # _similarity_.
  # gene_tree <- hclust(as.dist(1 - adj_matrix), method="average")
  gene_tree <- hclust(as.dist(dissTOM), method="average")
  
  # we will use the cuttreeDynamicTree method to break apart the hc dendrogram
  # into separate modules
  module_labels <- cutreeDynamicTree(dendro=gene_tree, minModuleSize=100,
                                     # distM = dissTOM,
                                         deepSplit=FALSE)
  gc()
  return(module_labels)
}


findSharedGenes <- function(cormat) {
  
  shared_genes <- vector(mode = "list", length = nrow(cormat))
  for (i in 1:nrow(cormat)) {
    inds_day = which(day_module_colors == substring(as.character(cormat[i,1]),3))
    inds_night = which(night_module_colors == substring(as.character(cormat[i,2]),3))
    shared_genes[[i]] <- intersect(names(day_module_colors[inds_day]), names(night_module_colors[inds_night]))
  }
  
  shared_genes <- list(cormat[[1]], cormat[[2]], cormat[[3]], shared_genes)
  
  library(stringi)
  shared_genes <- stri_list2matrix(shared_genes, byrow = TRUE)
  shared_genes <- `dim<-`(as.character(shared_genes), dim(shared_genes))
  shared_genes <- t(shared_genes)
  colnames(shared_genes) <- c('day module', 'night module', 'corr', 'shared genes')
  
  return(shared_genes)
}


listModules <- function(module_labels) {
  modules <- list()
  
  for (i in 1:max(module_labels)) {
    modules[[i]] <- names(module_labels[module_labels == i])
  }
  modules[[max(module_labels) + 1]] <- names(module_labels[module_labels == 0])
  return(modules)
}


#' Converts an adjaceny matrix along with some optional vertex and edge
#'  information to a GraphML graph and saves it to disk.
#'
#' @param adj_mat An n-by-n weighted or unweighted adjacency matrix normalized
#' to contain values between 0 and 1.
#' @param filename Name of file to save output to. If file already exists it
#' will be overwritten. (default: network.graphml)
#' @param weighted Whether or not the adjacency matrix should be treated as a 
#' weighted graph. (default: TRUE)
#' @param threshold For weighted networks, if a threshold value between 0 and 
#' 1 is specified, all edges with weights below that value with be dropped from
#'   the graph. (default: 0.5)
#' @param max_edge_ratio The maximum number of edges per node in the network to
#' allow. If the number of edges that would remain for the specified threshold
#' exceeds this value, the threshold will be raised to reduce the number of
#' edges remaining. (default: 3)
#' @param nodeAttr A vector with length equal to the number of vertices in the 
#' network, where the ith entry in the vector corresponds to some numeric or 
#' string annotation that should be associated with the ith node in the 
#' adjacency matrix. (default: NULL)
#' @param nodeAttrDataFrame A data frame containing one or more columns 
#' associated with the vertices in the graph.  The ith row of the dataframe 
#' should correspond to the ith entry in the adjacency matrix. (default: NULL)
#' @param edgeAttributes Extra attributes to associate with the graph edges,
#' formatted as a list of matrices of the same dimension and names as the
#' adjacency matrix.
#'
#' Examples
#' --------
#' export_network_to_graphml(adj_mat, filename='~/network.graphml',
#'                           threshold=0.3, nodeAttrDataFrame=df)
#'
#' See Also
#' --------
#' 1. http://www.inside-r.org/packages/cran/WGCNA/docs/exportNetworkToCytoscape
#' 2. http://graphml.graphdrawing.org/
#'
#' Returns
#' -------
#' An igraph graph object representing the exported graph.
export_network_to_graphml <- function (adj_mat, filename=NULL, weighted=TRUE,
                                       threshold=0.5, max_edge_ratio=3,
                                       nodeAttr=NULL, nodeAttrDataFrame=NULL,
                                       edgeAttributes=NULL, verbose=FALSE) {
  library('igraph')
  
  # Determine filename to use
  if (is.null(filename)) {
    filename='network.graphml'
  }
  
  # TODO 2015/04/09
  # Add option to rescale correlations for each module before applying
  # threshold (this is simpler than the previous approach of trying to
  # determine a different threshold for each module)
  #
  # Still, modules with very low correlations should be given somewhat
  # less priority than those with very high correlations.
  
  #module_colors <- unique(nodeAttrDataFrame$color)
  #module_genes <- which(nodeAttrDataFrame$color == color)
  #module_adjmat <- adj_mat[module_genes,]
  #num_genes <- length(module_genes)
  
  # Adjust threshold if needed to limit remaining edges
  max_edges <- max_edge_ratio * nrow(adj_mat)
  
  edge_to_total_ratio <- max_edges / length(adj_mat)
  edge_limit_cutoff <- as.numeric(quantile(abs(adj_mat), 1 - edge_to_total_ratio))
  
  # Also choose a minimum threshold to make sure that at least some edges
  # are left
  min_threshold <- as.numeric(quantile(abs(adj_mat), 0.9999))
  
  threshold <- min(min_threshold, max(threshold, edge_limit_cutoff))
  
  # Remove edges with weights lower than the cutoff
  adj_mat[abs(adj_mat) < threshold] <- 0
  
  # Drop any genes with no edges (TODO: Make optional)
  orphaned <- (colSums(adj_mat) == 0)
  adj_mat <- adj_mat[!orphaned, !orphaned]
  
  # Also remove annotation entries
  if (!is.null(nodeAttr)) {
    nodeAttr <- nodeAttr[!orphaned]
  }
  if (!is.null(nodeAttrDataFrame)) {
    nodeAttrDataFrame <- nodeAttrDataFrame[!orphaned,]
  }
  
  # Keep track of non-positive edges and rescale to range 0,1
  is_zero     <- adj_mat == 0
  is_negative <- adj_mat < 0
  
  adj_mat <- (abs(adj_mat) - threshold) / (max(adj_mat) - threshold)
  adj_mat[is_zero] <- 0
  adj_mat[is_negative] <- -adj_mat[is_negative]
  
  if (verbose) {
    message(sprintf("Outputting matrix with %d nodes and %d edges", 
                    nrow(adj_mat), sum(adj_mat > 0)))
  }
  
  # Create a new graph and add vertices
  # Weighted graph
  if (weighted) {
    g <- graph.adjacency(adj_mat, mode='undirected', weighted=TRUE, diag=FALSE)
  } else {
    adj_mat[adj_mat != 0] <- 1
    g <- graph.adjacency(adj_mat, mode='undirected', diag=FALSE)
  }
  
  # Add single node annotation from vector
  if (!is.null(nodeAttr)) {
    g <- set.vertex.attribute(g, "attr", value=nodeAttr)
  }
  
  # Add node one or more node annotations from a data frame
  if (!is.null(nodeAttrDataFrame)) {
    for (colname in colnames(nodeAttrDataFrame)) {
      g <- set.vertex.attribute(g, colname, value=nodeAttrDataFrame[,colname])
    }
  }
  
  edge_correlation_negative <- c()
  
  # neg_correlations[edge_list]
  edge_list <- get.edgelist(g)
  
  for (i in 1:nrow(edge_list)) {
    from <- edge_list[i, 1]    
    to   <- edge_list[i, 2]    
  }
  
  # Save graph to a file
  write.graph(g, filename, format='graphml')
  
  # return igraph
  return(g)
}
