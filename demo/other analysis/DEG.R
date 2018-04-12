source("http://bioconductor.org/biocLite.R")
biocLite("ballgown")
library(ballgown)

library(limma)
Sample <- rownames(datExpr[1:28,])
Status <- c(rep("day", 14), rep("night", 14))
pheno <- c(rep(1, 14), rep(0, 14))
pheno <- data.frame(Sample, Status, pheno)
##To design matrix---
Group<-factor(pheno$Status,levels=levels(pheno$Status))
design<-model.matrix(~0+Group)  
###Assigning colnames###
colnames(design)<-c("night", "day")
###To assign the designed matrix in linear model using limma
fit <-lmFit(t(datExpr[1:28,]),design)
###Designing contrast matrix#
cont.wt<-makeContrasts("day-night",levels=design)
fit2 <-contrasts.fit(fit,cont.wt)
## eBayes step for calculating p-values, fold change etc###
fit3<-eBayes(fit2)

colnames(fit3)
topTable(fit3,coef=1)

results <- decideTests(fit3)
summary(results)
vennDiagram(results)