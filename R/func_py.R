library(reticulate)
use_python("/home/dnguyen/anaconda3/bin/python")

source_python("python/distance.py")
source_python("python/neighborhood.py")
source_python("python/alignment.py")
source_python("python/cluster.py")
source_python("python/correspondence.py")
source_python("python/demo.py")

source_python("python/dtw.py")
source_python("python/embedding.py")

source_python("python/util.py")
source_python("python/viz.py")
source_python("python/warping.py")