EvoTreeClassifier(
  loss = EvoTrees.Softmax(), 
  nrounds = 10, 
  λ = 0.0, 
  γ = 0.0, 
  η = 0.1, 
  max_depth = 5, 
  min_weight = 1.0, 
  rowsample = 1.0, 
  colsample = 1.0, 
  nbins = 64, 
  α = 0.5, 
  metric = :mlogloss, 
  rng = Random.MersenneTwister(123), 
  device = "cpu")