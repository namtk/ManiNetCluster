library(RcppCNPy)
library(cluster)
library(mclust)
library(clues)
library(reshape2)
library(ggplot2)
library(ggthemes)

linwarp <- npyLoad("data/kmedoids_linwarp.npy", "integer")
linwarp_day <- linwarp[1:17695]
linwarp_night <- linwarp[17696:35390]
pam_day <- pam(prcomp(dayExpr)$rotation[,1:4], max(day_module_labels), diss = FALSE)
pam_night <- pam(prcomp(nightExpr)$rotation[,1:4], max(night_module_labels), diss = FALSE)
hc_day <- cutree(hclust(dist(prcomp(dayExpr)$rotation[,1:4])), k = max(day_module_labels))
hc_night <- cutree(hclust(dist(prcomp(nightExpr)$rotation[,1:4])), k = max(night_module_labels))
kmeans_day <- kmeans(t(dayExpr), max(day_module_labels))$cluster
kmeans_night <- kmeans(t(nightExpr), max(night_module_labels))$cluster
em_day <- Mclust(prcomp(dayExpr)$rotation[,1:4])[14]$classification
em_night <- Mclust(prcomp(nightExpr)$rotation[,1:4])[14]$classification

compare_df <- data.frame(matrix(vector(), 0, 2,
                                dimnames=list(c(), c("day", "night"))),
                         stringsAsFactors=F)
compare_df[1,1] <- adjustedRand(linwarp_day, day_module_labels)[1]
compare_df[1,2] <- adjustedRand(linwarp_night, night_module_labels)[1]
compare_df[2,1] <- adjustedRand(linwarp_day, hc_day)[1]
compare_df[2,2] <- adjustedRand(linwarp_night, hc_night)[1]
compare_df[3,1] <- adjustedRand(linwarp_day, kmeans_day)[1]
compare_df[3,2] <- adjustedRand(linwarp_night, kmeans_night)[1]
compare_df[4,1] <- adjustedRand(linwarp_day, em_day)[1]
compare_df[4,2] <- adjustedRand(linwarp_night, em_night)[1]
compare_df$id <- c("WGCNA +\nhierarchical\nclustering", 
                          "pca +\nhierarchical\nclustering", 
                          "kmeans",
                          "pca +\nexpectation\nmaximization")

comparedf_long <- melt(compare_df, id.vars="id")

ggplot(data = comparedf_long, aes(x = id, y = value, fill=variable, 
                                  # width = allGene/1000
                                  )) + 
  geom_bar(position = position_dodge(width = .5), stat = "identity", width = .5) + 
  xlab("method") +
  ylab("adjusted rand index") +
  theme_hc() +
  scale_fill_manual(values=c("#440154FF", "#FDE725FF"),
                    labels = c("day", "night"),
                    guide = guide_legend(
                      # direction = "horizontal",
                      title = "",
                      title.theme = element_text(
                        size = 12,
                        face = "bold",
                        # colour = "red",
                        # angle = 0
                      ),
                      # title.position = "top",
                      # label.position = "bottom",
                      # label.hjust = 0.5,
                      # label.vjust = 1,
                      label.theme = element_text(
                        size = 12,
                        # angle = 90
                      )
                    )
                    ) + 
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
  scale_y_continuous(expand = c(0, 0)) + # Remove area between x axis and x ticks
  scale_x_discrete(expand = c(0, 0)#,
                     # breaks = 1:60
                     # breaks = c(1,10,21,30,40,51,60)
  ) + 
  theme(axis.text=element_text(size=12, angle = 0),
        axis.title=element_text(size=12,face="bold"))
