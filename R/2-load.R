##############################################
### Load Gene Expression Profile (Input 1) ###
##############################################

# Read in the expression profile data set for both 'day' and 'night'
CreData = read.csv("data/processed/TPC2015-00498-LSBR1_Supplemental_Data_Set_1 (3).csv");
# Take a quick look at what is in the data set:
# dim(CreDta);
# names(CreDta);

datExpr0 = as.data.frame(t(CreData)[-1,]);
names(datExpr0) = CreData$Locus.ID..v5.5.;

# Convert all value of expression profile to numeric
datExpr0 = sapply(datExpr0, function(x){
  as.numeric(as.character(x))
})

rownames(datExpr0) = names(CreData[,-1])

###############################################
### Load (and Process) Ortho Data (Input 2) ###
###############################################

orthoData <- read.table('data/raw/inParanoid_Athalianacolumbia.167_Creinhardtii.281', fill = T, sep = '', header = F)[-1, c(3, 5, 7)]

wordstoremove <- c('Athalianacolumbia:', 'Creinhardtii:', '\\.t.\\..', '\\.\\d')
orthoData <- as.data.frame(sapply(orthoData, function(x)
  gsub(paste(wordstoremove, collapse = '|'), '', x)))#

orthoData$CreId <- as.character(apply(orthoData, 1, function(x)
  grep("Cre+", unlist(x), perl=TRUE, value=TRUE)))

orthoData <- orthoData[orthoData$CreId != "character(0)", ]

library(splitstackshape)
orthoData <- cSplit(orthoData, "CreId", ",", "long")

orthoData <- as.data.frame(sapply(orthoData, function(x)
  gsub(paste(c('c\\(', '\\"', '\\)'), collapse = '|'), '', x)))

orthoData[, 1:3] <- as.data.frame(sapply(orthoData[, 1:3], function(x)
  gsub(paste("Cre..........", collapse = '|'), '', x)))

orthoData <- orthoData[orthoData$V3 != "" | orthoData$V5 != "", ] # should use operator | here!

rownames(orthoData) <- orthoData$CreId

orthoData <- orthoData[, -c(3,4)]

write.csv(orthoData, file = 'output/orthoData.csv')