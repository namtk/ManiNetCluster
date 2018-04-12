library(RcppCNPy)
# source("https://bioconductor.org/biocLite.R")
# biocLite("org.At.tair.db")
library("BiocGenerics")
library("clusterProfiler")
library("org.At.tair.db")

kmedoids <- npyLoad("/Users/tkn/Downloads/kmedoids.npy", "integer")

mani_clust <- rbind(rep(colnames(dayExpr),2), kmedoids)
mani_clust <- t(mani_clust)
mani_clust <- cbind(mani_clust, c(rep("day", 17695), rep("night", 17695)))
colnames(mani_clust) <- c("geneid", "module", "time")
# rownames(mani_clust) <- mani_clust[, 1]
# mani_clust <- mani_clust[, -1]

for (i in 0:59) {
  lapply(unique(mani_clust[mani_clust[,2]==i, ][, 1]), write, paste("output/lin_warp_modules_genes/module_", i, ".txt", sep = ""), append=TRUE)
}

mani_modules_ortho <- merge(orthoData, mani_clust, by.x = 0, by.y = 1, all.y = TRUE)
# rownames(mani_modules_ortho) <- mani_modules_ortho$Row.names

x <- org.At.tairENTREZID
mapped_genes <- mappedkeys(x)

tairENID <- as.list(x[mapped_genes])

for (i in unique(mani_modules_ortho$module)) {
  gene <- stack(mani_modules_ortho[mani_modules_ortho$module == i, 2:3])$values
  gene <- gene[!is.na(gene)]
  gene <- gene[gene != ""]
  
  ego <- enrichGO(gene          = unlist(as.list(x[gene])),
                  universe      = unlist(tairENID),
                  OrgDb         = org.At.tair.db,
                  ont           = "MF",
                  pAdjustMethod = "BH",
                  pvalueCutoff  = 0.01,
                  qvalueCutoff  = 0.05,
                  readable      = TRUE)
  
  # night_modules_ortho[night_modules_ortho$y.x == i, 6] <- paste(ego$Description, collapse = ", ")
  len1 <- length(ego$Description)
  len2 <- length(mani_modules_ortho[mani_modules_ortho$module == i, 6])
  if (len1 != 0) {
    mani_modules_ortho[mani_modules_ortho$module == i, 6][1:max(1, min(len1, len2))] <- ego$Description[1:max(1, min(len1, len2))]
  }
}

colnames(mani_modules_ortho) <- c("geneID", "ortho", "ortho", "module", "time")#, "MF")
mani_modules_ortho <- mani_modules_ortho[order(mani_modules_ortho$module), ]

allGene_df <- as.data.frame(table(mani_modules_ortho$module))
dayGene_df <- as.data.frame(table(mani_modules_ortho[mani_modules_ortho$time == "day", ]$module))
nightGene_df <- as.data.frame(table(mani_modules_ortho[mani_modules_ortho$time == "night", ]$module))

sameGene <- c()
for (i in allGene_df$Var1) {
  tbl <- table(mani_modules_ortho[mani_modules_ortho$module==i, ]$geneID)
  sameGene <- c(sameGene, sum(as.data.frame(tbl)$Freq==2))
}

fraction <- sameGene/allGene_df$Freq

orthoGene <- c()
for (i in allGene_df$Var1) {
  gene <- stack(mani_modules_ortho[mani_modules_ortho$module == i, 2:3])$values
  gene <- gene[!is.na(gene)]
  gene <- gene[gene != ""]
  gene <- unique(gene)
  orthoGene <- c(orthoGene, length(gene))
}

MF <- c()
for (i in allGene_df$Var1) {
  MF <- c(MF, paste(na.omit(mani_modules_ortho[mani_modules_ortho$module==i, ]$MF), collapse = " | "))
}

mani_df <- cbind(allGene_df$Freq, dayGene_df$Freq, nightGene_df$Freq, sameGene, fraction, orthoGene, MF)
colnames(mani_df) <- c("allGene", "dayGene", "nightGene", "sameGene", "fraction", "orthoGene", "MF")
rownames(mani_df) <- allGene_df$Var1

write.csv(mani_df, "output/maniWarp_clust_summary.csv")
write.csv(mani_modules_ortho, "output/maniWarp_clust_full.csv")

#########################
### countSharedGene.R ###
#########################
mat <- matrix(, nrow = 30, ncol = 34)
for (i in 1:30) {
  for (j in 1:34) {
    mat[i,j] <- length(unique(intersect(dayModules[[j]], nightModules[[i]])))/
      # max(length(dayModules[[j]]), length(nightModules[[i]]))
      length(unique(union(dayModules[[j]], nightModules[[i]])))
  }
}

linwarp_frac <- fraction
linman_frac <- fraction
frac_compare_df <- as.data.frame(cbind(rep(linman_frac, 17), rep(linwarp_frac, 17), c(mat)))
colnames(frac_compare_df) <- c("linM_alig", "linM_warp", "wgcna")
boxplot(frac_compare_df, las=2)
boxplot(cbind(rep(linman_frac, 17), rep(linwarp_frac, 17), c(mat)), las=2)