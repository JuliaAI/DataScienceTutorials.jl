BlendedRegressor(
  knn_model = KNNRegressor(
        K = 5, 
        algorithm = :kdtree, 
        metric = Distances.Euclidean(0.0), 
        leafsize = 10, 
        reorder = true, 
        weights = NearestNeighborModels.Uniform()), 
  ridge_model = RidgeRegressor(
        lambda = 2.5, 
        bias = true), 
  knn_weight = 0.3)