import numpy as np
import scipy.spatial.distance as sd
from sklearn.metrics.pairwise import euclidean_distances
# from itertools import izip
try:
    # Python 2
    from itertools import izip
except ImportError:
    # Python 3
    izip = zip

'''Distance functions, grouped by metric.'''

