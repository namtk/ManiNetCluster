stats <- read.csv('data/stats.csv')[,-c(5,6,8)]
module.summary <- read.csv('data/maniWarp_clust_summary_colored.csv')[-c(61:66),c(1:5)]
colnames(module.summary)[colnames(module.summary)=="module"] <- "Module"
stats <- merge(stats, module.summary)
stats1 <- stats[stats$Statsics.on == 'X',]
stats2 <- stats[stats$Module == 59,]
terms <- c('protein.postranslational modification',
           'DNA.synthesis/chromatin structure.histone',
           'lipid metabolism',
           'protein.postranslational modification',
           'RNA.RNA binding',
           'RNA.transcription',
           'cell.division',
           'cell.motility.eukaryotes.flagellar associated proteins',
           'lipid metabolism.lipid degradation.lysophospholipases.carboxylesterase',
           'RNA.regulation of transcription.PHD finger transcription factor',
           'transport.ABC transporters and multidrug resistance systems',
           'protein.degradation.ubiquitin.proteasom',
           'protein.folding',
           'mitochondrial electron transport / ATP synthesis.NADH-DH.localisation not clear',
           'PS.lightreaction.photosystem I.PSI polypeptide subunits')
phyper(18,
       sum(grepl(terms[1], stats$MapMan)),
       17695 - sum(grepl(terms[1], stats$MapMan)),
       314 - 18)
phyper(35,
       sum(grepl(terms[2], stats$MapMan)),
       17695 - sum(grepl(terms[2], stats$MapMan)),
       279 - 35)
phyper(8,
       sum(grepl(terms[3], stats$MapMan)),
       17695 - sum(grepl(terms[3], stats$MapMan)),
       391 - 8)
stats2$x <- sapply(stats2$MapMan, function(x) sum(grepl(gsub('[0-9]+', '', x), stats$MapMan)))
stats2$pvalue.day <- phyper(stats2$Frequency -1,
                            stats2$x,
                            17695 - stats2$x,
                            stats2$dayGene,
                            lower.tail= FALSE)
stats2$pvalue.night <- phyper(stats2$Frequency -1,
                              stats2$x,
                              17695 - stats2$x,
                              stats2$nightGene,
                              lower.tail= FALSE)
stats2$pvalue.same <- phyper(stats2$Frequency -1,
                             stats2$x,
                             17695 - stats2$x,
                             stats2$sameGene,
                             lower.tail= FALSE)
stats2$pvalue.all <- phyper(stats2$Frequency -1,
                            stats2$x,
                            17695 - stats2$x,
                            as.numeric(stats2$allGene),
                            lower.tail= FALSE)
write.csv(stats2, file = 'output/pvalue-59.csv')

install.packages('VennDiagram')
library(VennDiagram)
draw.pairwise.venn(area1 = 295, area2 = 284, cross.area = 19, category = c("day", 
                                                                         "night"))
