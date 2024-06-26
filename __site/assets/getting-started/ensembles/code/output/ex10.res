DeterministicEnsembleModel(
  model = KNNRegressor(
        K = 10, 
        algorithm = :kdtree, 
        metric = Distances.Euclidean(0.0), 
        leafsize = 10, 
        reorder = true, 
        weights = NearestNeighborModels.Uniform()), 
  atomic_weights = Float64[], 
  bagging_fraction = 0.8, 
  rng = Random._GLOBAL_RNG(), 
  n = 20, 
  acceleration = ComputationalResources.CPU1{Nothing}(nothing), 
  out_of_bag_measure = Any[])