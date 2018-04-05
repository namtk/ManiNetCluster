source("https://bioconductor.org/biocLite.R")
biocLite("org.At.tair.db")
library("BiocGenerics")
library("clusterProfiler")
library("org.At.tair.db")

x <- org.At.tairENTREZID
mapped_genes <- mappedkeys(x)

tairENID <- as.list(x[mapped_genes])
# universe = c(night_modules_ortho$V3, night_modules_ortho$V5)

# night_modules_ortho$V6 <- NA
# gene <- stack(night_modules_ortho[night_modules_ortho$y.x == "orange", 2:3])$values
# gene <- gene[gene != ""]
# 
# ego <- enrichGO(gene          = unlist(as.list(x[gene])),
#                 universe      = unlist(tairENID),
#                 OrgDb         = org.At.tair.db,
#                 ont           = "MF",
#                 pAdjustMethod = "BH",
#                 pvalueCutoff  = 0.01,
#                 qvalueCutoff  = 0.05,
#                 readable      = TRUE)
# 
# # night_modules_ortho[night_modules_ortho$y.x == i, 6] <- paste(ego$Description, collapse = ", ")
# len1 <- length(ego$Description)
# len2 <- length(night_modules_ortho[night_modules_ortho$y.x == "orange", 6])
# if (len1 != 0) {
#   night_modules_ortho[night_modules_ortho$y.x == "orange", 6][1:max(1, min(len1, len2))] <- ego$Description[1:max(1, min(len1, len2))]
# }

for (i in unique(night_modules_ortho$y.x)) {
  gene <- stack(night_modules_ortho[night_modules_ortho$y.x == i, 2:3])$values
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
  len2 <- length(night_modules_ortho[night_modules_ortho$y.x == i, 6])
  if (len1 != 0) {
    night_modules_ortho[night_modules_ortho$y.x == i, 6][1:max(1, min(len1, len2))] <- ego$Description[1:max(1, min(len1, len2))]
  }
}

for (i in unique(day_modules_ortho$y.x)) {
  gene <- stack(day_modules_ortho[day_modules_ortho$y.x == i, 2:3])$values
  gene <- gene[gene != ""]
  
  ego <- enrichGO(gene          = unlist(as.list(x[gene])),
                  universe      = unlist(tairENID),
                  OrgDb         = org.At.tair.db,
                  ont           = "MF",
                  pAdjustMethod = "BH",
                  pvalueCutoff  = 0.01,
                  qvalueCutoff  = 0.05,
                  readable      = TRUE)
  
  # day_modules_ortho[day_modules_ortho$y.x == i, 6] <- paste(ego$Description, collapse = ", ")
  len1 <- length(ego$Description)
  len2 <- length(day_modules_ortho[day_modules_ortho$y.x == i, 6])
  if (len1 != 0) {
    day_modules_ortho[day_modules_ortho$y.x == i, 6][1:max(1, min(len1, len2))] <- ego$Description[1:max(1, min(len1, len2))]
  }
}

write.csv(day_modules_ortho, file = 'output/day_modules_ortho_func.csv')
write.csv(night_modules_ortho, file = 'output/night_modules_ortho_func.csv')
