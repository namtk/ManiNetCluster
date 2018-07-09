library(viridis)
library(ggplots)

heatxy = matrix(
  c(rep(0,7),1,1,1,
    rep(0,7),1,1,1,
    rep(0,7),1,1,1,
    rep(0,10),
    rep(0,10),
    rep(0,10),
    -1,-1,-1,rep(0,7),
    -1,-1,-1,rep(0,7),
    rep(0,10),
    rep(0,10)), # the data elements 
  nrow=10,              # number of rows 
  ncol=10,              # number of columns 
  byrow = TRUE)        # fill matrix by rows

heatx = matrix(
  c(rep(0,8),1,1,
    rep(0,8),1,1,
    rep(0,5),2,2,2,0,0,
    rep(0,5),2,2,2,0,0,
    rep(0,5),2,2,2,0,0,
    0,0,-2,-2,-2,rep(0,5),
    0,0,-2,-2,-2,rep(0,5),
    0,0,-2,-2,-2,rep(0,5),
    rep(0,10),
    rep(0,10)), # the data elements 
  nrow=10,              # number of rows 
  ncol=10,              # number of columns 
  byrow = TRUE)        # fill matrix by rows

heaty = matrix(
  c(rep(0,7),3,3,3,
    rep(0,7),3,3,3,
    rep(0,7),3,3,3,
    rep(0,10),
    0,0,0,-3,-3,-3,rep(0,4),
    0,0,0,-3,-3,-3,rep(0,4),
    0,0,0,-3,-3,-3,rep(0,4),
    4,4,4,rep(0,7),
    4,4,4,rep(0,7),
    4,4,4,rep(0,7)), # the data elements 
  nrow=10,              # number of rows 
  ncol=10,              # number of columns 
  byrow = TRUE)        # fill matrix by rows

Noisify <- function(data, grain) {
  
  if (is.vector(data)) {
    noise <- runif(length(data), -grain, grain)
    noisified <- data + noise
  } else {
    length <- dim(data)[1] * dim(data)[2]
    noise <- matrix(runif(length, -grain, grain), dim(data)[1])
    noisified <- data + noise
  }
  return(noisified)
}

heatxy <- Noisify(heatxy, .4)
heatx <- Noisify(heatx, .5)
heaty <- Noisify(heaty, .5)

heatmap.2(heatxy, Rowv=NA, Colv=NA, trace="none",
          col=viridis_pal(option = "D")(100),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))
heatmap.2(heatx, Rowv=NA, Colv=NA, trace="none",
          col=colorRampPalette(c("#deebf7", "#9ecae1", "#3182bd")),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))
heatmap.2(heaty, Rowv=NA, Colv=NA, trace="none",
          col=colorRampPalette(c("#31a354", "#a1d99b", "#e5f5e0")),
          key = F,
          lmat = matrix(c(4,2,3,1),
                        nrow=2,
                        ncol=2),
          lhei = c(0.1,0.9),
          lwid = c(0.3,0.7))

