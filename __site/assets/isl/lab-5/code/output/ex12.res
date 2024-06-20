DeterministicTunedModel(
  model = DeterministicPipeline(
        feature_selector = FeatureSelector(features = [:hp1, :hp2, :hp3], …), 
        linear_regressor = LinearRegressor(fit_intercept = true, …), 
        cache = true), 
  tuning = RandomSearch(
        bounded = Distributions.Uniform, 
        positive_unbounded = Distributions.Gamma, 
        other = Distributions.Normal, 
        rng = Random._GLOBAL_RNG()), 
  resampling = CV(
        nfolds = 10, 
        shuffle = false, 
        rng = Random._GLOBAL_RNG()), 
  measure = RootMeanSquaredError(), 
  weights = nothing, 
  class_weights = nothing, 
  operation = nothing, 
  range = NominalRange(feature_selector.features = [:x1], [:x1, :x2], [:x1, :x2, :x3], ...), 
  selection_heuristic = MLJTuning.NaiveSelection(nothing), 
  train_best = true, 
  repeats = 1, 
  n = nothing, 
  acceleration = ComputationalResources.CPU1{Nothing}(nothing), 
  acceleration_resampling = ComputationalResources.CPU1{Nothing}(nothing), 
  check_measure = true, 
  cache = true, 
  compact_history = true, 
  logger = nothing)