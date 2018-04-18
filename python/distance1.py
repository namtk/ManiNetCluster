class Metric(object):
  def __init__(self,dist,name):
    self.dist = dist  # dist(x,y): distance between two points
    self.name = name

  def within(self,A):
    '''pairwise distances between each pair of rows in A'''
    return sd.squareform(sd.pdist(A,self.name),force='tomatrix')

  def between(self,A,B):
    '''cartesian product distances between pairs of rows in A and B'''
    return sd.cdist(A,B,self.name)

  def pairwise(self,A,B):
    '''distances between pairs of rows in A and B'''
    return np.array([self.dist(a,b) for a,b in izip(A,B)])
    