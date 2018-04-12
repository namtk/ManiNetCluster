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
```