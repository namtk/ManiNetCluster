# ManiNetCluster
Simultaneous clustering on manifold of time series gene expression profiles

author: "[Nam Nguyen]"

date: "April 12, 2018"

---
To use this package, you 
will need the R statistical computing environment (version 3.4.1 or later)
and several packages available through Bioconductor and CRAN.

This release supports Windows 10. ManiNetCluster has not been tested with Mac and Linux operating systems.

The following license governs the use of ManiNetCluster in academic and educational environments. Commercial use requires a commercial license from the Owner of the copyright. Please check the license.pdf file for more details.

---

# Abstract 
Gene expression profiles are often used to find patterns among regulated genes. ManiNetCluster is a tool for quantitative comparison of expression dynamics within or between organism/species. The **input** to the ManiNetCluster workflow is any **expression profile**  and the **orthologs** or the **correspoding information**. This vignette provides an overview of gene expression analysis workflow with ManiNetCluster describing both the alignment and the clustering. 

# To begin
ManiNetCluster 
First you will need to download the package from github 

Start by installing the devtools package from CRAN and load it

Installation should take less than one minute.

```{r eval=FALSE}
install.packages("devtools")
library(devtools)
```

install ManiNetCluster and load it

```{r eval=FALSE}
install_github("namtk/ManiNetCluster")
```
```{r}
library(ManiNetCluster)

```
The following demo is provided to walk you through the basic functionality of ManiNetCluster. It should take less than 10 minutes to complete on a standard desktop computer.

# Introduction 
ManiNetCluster is a package that takes as input two or more gene expression profiles, and the gene correspondences or orthologs. ManiNetCluster has 3 essential steps:

1. Construct gene co-expression networks from gene expression data

2. Align networks incrementally in pseudo-time using manifold alignment and warping techniques 

3. Cluster genes into modules of four different types (type A: conserved modules, type B, type C: specific-specific modules, type D: functional conectivity modules.

At this point, users could use any enrichment analysis to annotate the modules, and especially to reveal functional connectivity between organisms/conditions.

Included in our package is an example: Cre data set provided by BNL of the ManiNetCluster publication. They are Cre time series gene expressions divided into day time and night time for the study of photosynthesis - preprocessed to eliminate bad gene reads with fewer than 16000 genes measured. Here we include an approximate 30 gene modules for day activities and approximate 30 modules for night activities. We used a technique called manifold warping for alignment of these data. The user should pre-process his or her own data in a technically and biologically relevant way for each sample for comparison.

```{r include = FALSE}
# divide data into "day" and "night" data
dayExpr = (datExpr[1:13, ] + datExpr[29:41, ]) / 2;
write.csv(dayExpr, file = "./output/dayExpr.csv");
nightExpr = (datExpr[14:28, ] + datExpr[42:56, ]) / 2;
write.csv(nightExpr, file = "./output/nightExpr.csv")


```

Network construction and modules separately labeling
-----
The first step is to construct gene co-expression networks and to detect modules for each network separately. We included this step for the comparision to simultaneous clustering in the later steps.  

```{r fig.height=5}
# day_adj_mat <- matrix(, nrow = nGenes, ncol = nGenes)
day_module_labels <- cordist_netConstruct(dayExpr, 20)
names(day_module_labels) <- colnames(dayExpr)

# assign a color to each module for easier visualization and referencing
day_module_colors <- labels2colors(day_module_labels)
names(day_module_colors) <- colnames(dayExpr)

# night_adj_mat <- matrix(, nrow = nGenes, ncol = nGenes)
night_module_labels <- cordist_netConstruct(nightExpr, 20)
names(night_module_labels) <- colnames(nightExpr)

# assign a color to each module for easier visualization and referencing
night_module_colors <- labels2colors(night_module_labels)
names(night_module_colors) <- colnames(nightExpr)

```