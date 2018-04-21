ManiNetCluster <- function(X,Y,corr=NULL,d=3,method='linear manifold',k=5) {
  Wx <- neighbor_graph(X, k=k)
  Wy <- neighbor_graph(Y, k=k)
  aligners <- c(
    function() TrivialAlignment(X,Y,d),
    function() Affine(X,Y,corr,d),
    function() Procrustes(X,Y,corr,d),
    function() CCA(X,Y,corr,d),
    function() CCAv2(X,Y,d),
    function() ManifoldLinear(X,Y,corr,d,Wx,Wy),
    function() ctw(X,Y,d)[1],
    function() manifold_warping_linear(X,Y,d,Wx,Wy)[1],
    
    # function() (X, dtw(X,Y).warp(X)),
    function() manifold_nonlinear(X,Y,corr,d,Wx,Wy)#,
    # function() manifold_warping_nonlinear(X,Y,d,Wx,Wy)[1:],
    # function() manifold_warping_twostep(X_normalized, Y_normalized, d, Wx, Wy)[1:]
  )
  names(aligners) <- c(
    'no alignment',
    'affine',
    'procrustes',
    'cca',
    'cca_v2',
    'linear manifold',
    'ctw',
    'manifold warping',
    
    # 'dtw',
    'nonlinear manifold aln'#,
    # 'nonlinear manifold warp',
    # 'manifold warping two-step'
  )
  Xnew <- aligners[[method]]()$project(X, Y)[[1]]
  Ynew <- aligners[[method]]()$project(X, Y)[[2]]
  print(paste(' sum sq. error =', pairwise_error(Xnew, Ynew, metric=SquaredL2)))
}