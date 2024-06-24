DeterministicTunedModel(
  model = NeuralNetworkRegressor(
        builder = MyNetworkBuilder(n1 = 20, …), 
        optimiser = Flux.Optimise.Adam(0.001, (0.9, 0.999), 1.0e-8, IdDict{Any, Any}()), 
        loss = Flux.Losses.mse, 
        epochs = 15, 
        batch_size = 2, 
        lambda = 0.0, 
        alpha = 0.0, 
        rng = Random._GLOBAL_RNG(), 
        optimiser_changes_trigger_retraining = false, 
        acceleration = ComputationalResources.CPU1{Nothing}(nothing)), 
  tuning = RandomSearch(
        bounded = Distributions.Uniform, 
        positive_unbounded = Distributions.Gamma, 
        other = Distributions.Normal, 
        rng = Random._GLOBAL_RNG()), 
  resampling = Holdout(
        fraction_train = 0.7, 
        shuffle = false, 
        rng = Random._GLOBAL_RNG()), 
  measure = LPLoss(p = 2), 
  weights = nothing, 
  class_weights = nothing, 
  operation = nothing, 
  range = MLJBase.NumericRange{Int64, MLJBase.Bounded, Symbol}[NumericRange(1 ≤ batch_size ≤ 5; origin=3.0, unit=2.0)], 
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