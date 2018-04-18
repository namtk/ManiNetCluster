class SparseL2Metric(Metric):
  '''scipy.spatial.distance functions don't support sparse inputs,
  so we have a separate SparseL2 metric for dealing with them'''
  def __init__(self):
    Metric.__init__(self, euclidean_distances, 'sparseL2')

  def within(self, A):
    return euclidean_distances(A,A)

  def between(self,A,B):
    return euclidean_distances(A,B)

  def pairwise(self,A,B):
    '''distances between pairs of rows in A and B'''
    return Metric.pairwise(self, A, B).flatten()
    