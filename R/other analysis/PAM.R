library("cluster")
library("factoextra")

day_adj_mat <- readRDS(file = "output/dayExpr_mat.rds")
night_adj_mat <- readRDS(file = "output/nightExpr_mat.rds")

pam_day <- pam(as.dist(1 - day_adj_mat), 9)
pam_night <- pam(as.dist(1 - night_adj_mat), 9)

table(pam_day$clustering)
pam_day$clusinfo

table(pam_night$clustering)
pam_night$clusinfo

fviz_cluster(pam_day)