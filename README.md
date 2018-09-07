# ManiNetCluster
Simultaneous clustering on manifold time series gene expression profiles

author: Nam Nguyen, Ian Blaby, Daifeng Wang

date: April 12, 2018

---
To use this package, you will need both the R statistical computing environment (version 3.4.1 or later) and Python (version 3.6.1 or later). The Python environment depends on numpy, scipy, matplotlib, and scikit-learn.

ManiNetCluster has been tested with Mac and Linux operating systems.

The following license governs the use of ManiNetCluster in academic and educational environments. Commercial use requires a commercial license from the Owner of the copyright. Please check the license.pdf file for more details.

---

# Abstract 
Gene expression profiles are often used to find patterns among co-regulated genes. ManiNetCluster is a tool for quantitative comparison of expression dynamics within or between organism/species. The **input** to the ManiNetCluster workflow is any **gene expression profile**. If pan-organism comparisons are being made, a  table  of **orthologs** is also required.

The  following text provides an overview of gene expression analysis workflow with ManiNetCluster describing both gene clustering and  alignment. The workflow of ManiNetCluster is depicted in the figure below:

|![](ManiNetCluster/figs/tut/Screen Shot 2018-09-07 at 3.53.01 PM.png "ManiNetCluster Schematic Workflow")|
|:--:| 
| *ManiNetCluster Schematic Workflow: (A) The inputs of the workflow are the two time series gene expression profiles across different conditions. The dimensions of the two datasets (i.e. the number of genes and the number of timepoints) need not be the same in each dataset. (B) From the input data, we construct the gene co-expression neighborhood networks which approximate the manifolds where the datasets are concentrated. (C) using the manifold alignment and manifold warping methods, we align the two gene expression profiles across time series in a common manifold. D) aligned data from both datasets, now embedded in the same manifold, are clustered into modules. Four types of modules are revealed in this step: conserved modules (type I), data1-specific modules (type II), data2-specific modules (type III), and function linkage modules (type IV).* |

# To begin
First you will need to download the package from github. To seamlessly integrate both Python and R in the same environment, you will need to install the reticulate package. 

```r
install.packages("reticulate")
```

Then, you can start by installing the devtools package from CRAN and load it. Installation should take less than one minute.

```r
install.packages("devtools")
```

Now, you specify the Python library for reticulate:

```r
reticulate::use_python("/Users/tkn/anaconda3/bin/python")
reticulate::py_config()
```

Finally, install ManiNetCluster and load it:

```r
devtools::install_github("namtk/ManiNetCluster")
library(ManiNetCluster)
```

The following demo is provided to walk through the basic functionality of ManiNetCluster. It should take less than 10 minutes to complete on a standard desktop computer.

# Introduction 
ManiNetCluster is a package that takes as input two or more gene expression profiles, and the gene correspondences  (i.e. orthologs) for  cross-species  comparison. ManiNetCluster has 3 essential steps:

1. Construct gene co-expression networks from gene expression data

2. Align the networks incrementally in pseudo-time using manifold alignment and warping techniques 

3. Cluster genes into modules of four different types (type A: conserved modules, type B, type C: specific-specific modules, type D: functional connectivity modules.

Included  in  our  package  is  an  example dataset. These  data are published  in (1) and  describe  a day/night  timecourse  of  synchronized  cultures  of  a  green  alga.

We provided here the sample data of time series gene expression data of Chlamydomonas reinhardtii. The full dataset includes more than 17000 genes but in this example, to demonstrate cross-species comparison, we have limited the data to genes which have orthologs (as determined by InParanoid8 (2)) by taking genes being orthologous to Arabidopsis thaliana. Users can find the data (in .csv format) in the github repository (namtk/ManiNetCluster/data/).

The first step is to load the data:

```r
X <- as.matrix(read.csv("Downloads/dayOrthoExpr.csv", row.names=1))
Y <- as.matrix(read.csv("Downloads/nightOrthoExpr.csv", row.names=1))
```

# Main Function: ManiNetCluster
In our package, we provide multiple functions that users can use for separately constructing networks, detecting modules, projecting data into a manifold. But, for convenience, we provide the wrapper function, called ManiNetCluster, which takes two matrices describing the gene expression time series (where rows are genes and columns are timepoints) as inputs and output the projected data in a common manifold and the modules into which the genes are clustered. Users must also provide the corresponding matrix encapsulating the correspondence between two datasets (such as ortholog information). To specify such a corresponding matrix, users must use the class Correspondence provided in our package. The usage is easy as follow: (Here, we use an identity matrix for correspondence since the datasets include the same set of genes in different timepoints)

```r
n <- nrow(X) # the number of genes in the dataset
corr <- Correspondence(matrix=diag(n))
```

Other parameters could be tunes are the names of datasets, the dimension of manifold to output, the method, the number of nearest neighbors for approximated graph construction, and the number of modules users want to output. The example use of the function is as follow:

```r
df <- ManiNetCluster(X,Y,nameX='day',nameY='night',corr=corr,d=3L,method='linear manifold',k_NN=6L,k_medoids=60L)
df <- ManiNetCluster(X,Y,nameX='day',nameY='night',corr=diag(nrow(X)),d=3L,method='linear manifold',k_NN=6L,k_medoids=60L)
```

Then we could add the locid of genes to the output dataframe by using this line of code:

```r
df$id <- c(read.csv("Downloads/dayOrthoExpr.csv")[,1], read.csv("Downloads/nightOrthoExpr.csv")[,1])
```

In the code above, we would like to specify the names of datasets as ‘day’ and ‘night’, the correspondence matrix is identity as calculated previously; the dimension is 3, the method using is linear manifold (we provide other manifold which will be presented later in this tutorial); number of nearest neighbors is 6; and numbers of modules is 60.

The output is the dataframe as follow:

| | Val1 | Val2 | Val3 | data | module | id |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | -2.6434931 | -0.146657079 | 0.008016877 | day | 15 | Cre01.g002200 |
| 2 | -1.6242314 | 0.302633402 | 0.080689364 | day | 19 | Cre01.g002350 |
| 3 | -1.4356133 | -0.768342141 | 0.001276283 | day | 27 | Cre01.g003376 |
| 4 | -4.0854834 | -0.415335251 | -0.204782870 | day | 13 | Cre01.g007051 |
| 5 | -1.4089036 | 0.462236245 | -0.069898261 | day | 8 | Cre01.g008000 |
| 6 | -1.2170322 | -0.784766106 | -0.205207899 | day | 22 | Cre01.g010848 |

# Visualization and Comparing the non alignment and alignment results
One method to visualize the alignment result is to use gradient color to capture the local alignment. In this method, same genes from two dataset (or genes which has correspondence to each other) are depicted by the same color. We fix one dataset and color the genes by sorting the expression level of genes by increasing order as in this code:

```r
df1 <- df[df$data == 'day',]
df2 <- df[df$data == 'night',]
df1 <- df1[order(df1$Val1,df1$Val2,df1$Val3), ]
df2 <- df2[match(df1$id, df2$id), ]
```

We use the rgl library for live visualization of data points by points:

```r
pal <- rainbow(n)
library(rgl)
for (i in 1:n) {
  with(df1[i,],points3d(Val1,Val2,Val3,size=7,col=pal[i], alpha=.1))
}
```

Using the above, the data points of dataset 1 will form a rainbow cloud as depicted in the figure below:

|![](figs/tut/Screen%20Shot%202018-05-03%20at%2012.58.19%20AM.png "day time gene expression when applying linear manifold")|
|:--:| 
| *day time gene expression when applying linear manifold* |

If the two datasets are well aligned, we will see the two things: (1) the range of color will keep the same order, and (2) the scale of the plot will approximate the scale of dataset 1 plot. This is because the objective function of manifold alignment/warping tries to minimize both local similarity (depicted by color of the neighborhood) and the global distance between two datasets (depicted by the range of plot). The code and the plot are as follows:

```r
for (i in 1:n) {
  with(df2[i,],points3d(Val1,Val2,Val3,size=7,col=pal[i]))
}
```

|![](figs/tut/Screen%20Shot%202018-05-03%20at%2012.59.20%20AM.png "night time gene expression when applying linear manifold")|
|:--:| 
| *night time gene expression when applying linear manifold* |

Additionally, we can plot them in the same coordinators as follow:

|![](figs/tut/Screen%20Shot%202018-05-03%20at%201.01.55%20AM.png "day and night time gene expression when applying linear manifold")|
|:--:| 
| *day and night time gene expression when applying linear manifold* |

From these plots, it is apparent that the alignment is good because the range of color (local similarity) and the scale of plot (global distance) is preserved. We can compare this alignment result with unalignment one. To plot the original datasets we use PCA, the code is as follows:

```r
pca_coordinatesX=prcomp(X)$x
df1 <- data.frame(pca_coordinatesX[,1:3])
names(df1) <- c('Val1', 'Val2', 'Val3')
df1$id <- read.csv("Downloads/dayOrthoExpr.csv")[,1]

pca_coordinatesY=prcomp(Y)$x
df2 <- data.frame(pca_coordinatesY[,1:3])
names(df2) <- c('Val1', 'Val2', 'Val3')
df2$id <- read.csv("Downloads/nightOrthoExpr.csv")[,1]

df1 <- df1[order(df1$Val1,df1$Val2,df1$Val3), ]
df2 <- df2[match(df1$id, df2$id), ]

for (i in 1:n) {
  with(df1[i,],points3d(Val1,Val2,Val3,size=7,col=pal[i], alpha=.1))
}

for (i in 1:n) {
  with(df2[i,],points3d(Val1,Val2,Val3,size=7,col=pal[i]))
}
```

Below is the plot of dataset 1:

|![](figs/tut/Screen%20Shot%202018-05-03%20at%201.06.02%20AM.png "day time gene expression when applying PCA")|
|:--:| 
| *day time gene expression when applying PCA* |

And dataset 2 is as follows:

|![](figs/tut/Screen%20Shot%202018-05-03%20at%201.07.02%20AM.png "night time gene expression when applying PCA")|
|:--:| 
| *night time gene expression when applying PCA* |

When plotted simultaneously:

|![](figs/tut/Screen%20Shot%202018-05-03%20at%201.09.37%20AM.png "day and night time gene expression when applying PCA")|
|:--:| 
| *day and night time gene expression when applying PCA* |

This plot demonstrates poor alignment as indicated by absence of scale and color gradient preservation. Thus, the results of alignment, inspected by visualization, is proved to be better than pure PCA.

### Reference
1. J. M. Zones,  I.  K.  Blaby,  S.  S.  Merchant,  J.  G.  Umen,  High-Resolution  Profiling  of  a  Synchronized  Diurnal  Transcriptome  from  Chlamydomonas  reinhardtii  Reveals  Continuous  Cell  and  Metabolic  Differentiation.  *Plant  Cell* **27**,  2743-2769  (2015). 
2. Erik L.L.Sonnhammer and Gabriel Östlund. InParanoid 8: orthology analysis between 273 proteomes, mostly eukaryotic Nucleic Acids Res. 43:D234-D239 (2015)
