library(RcppCNPy)
library(pdist)
# library(GGally)
library(viridis)
library(gplots)

X <- npyLoad('inst/python/Xnew.npy')
Y <- npyLoad('inst/python/Ynew.npy')

modules <- npyLoad('data/kmedoids_linwarp.npy', "integer")
modulesX <- modules[1:17695]
modulesY <- modules[17696:35390]

# conserved <- 20
# Xspec <- 50
# Yspec <- 59
# type4 <- 39

X <- as.data.frame(cbind(X, modulesX))
Y <- as.data.frame(cbind(Y, modulesY))

subset <- 
  union(
    rownames(X[X$modulesX==20 | X$modulesX==50 | X$modulesX==59 | X$modulesX==39, ]),
    rownames(Y[Y$modulesY==20 | Y$modulesY==50 | Y$modulesY==59 | Y$modulesY==39, ])
    )

X <- X[rownames(X) %in% subset, ]
Y <- Y[rownames(Y) %in% subset, ]

# X$modulesX <- as.factor(X$modulesX)
# Y$modulesY <- as.factor(Y$modulesY)
# ggparcoord(X, columns = 1:3, groupColumn = 'modulesX', scale = 'globalminmax')
# ggparcoord(Y, columns = 1:3, groupColumn = 'modulesY', scale = 'globalminmax')

# X <- X[order(X$modulesX), ]
# Y <- Y[match(rownames(X), rownames(Y)), ]
Y <- Y[order(Y$modulesY), ]
X <- X[match(rownames(Y), rownames(X)), ]

XX <- pdist(X, X)
XX <- as.matrix(XX)
# heatmap(XX, Rowv=NA, Colv=NA)

XY <- pdist(X, Y)
XY <- as.matrix(XY)
# heatmap(XY, Colv=NA, Rowv=NA)

YY <- pdist(Y, Y)
YY <- as.matrix(YY)
# heatmap(YY, Rowv=NA, Colv=NA)

heatmap.2(XY, Rowv=NA, Colv=NA, trace="none",
          # col=viridis_pal(option = "D")(100),
          col=colorRampPalette(c("#f0f0f0", "#bdbdbd", "#636363")),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))
heatmap.2(XX, Rowv=NA, Colv=NA, trace="none",
          col=colorRampPalette(c("#f0f0f0", "#bdbdbd", "#636363")),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))
heatmap.2(YY, Rowv=NA, Colv=NA, trace="none",
          col=colorRampPalette(c("#f0f0f0", "#bdbdbd", "#636363")),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))
