DeterministicTunedModel(
    model = KNNRidgeBlend(
            knn_model = KNNRegressor,
            ridge_model = RidgeRegressor,
            knn_weight = 0.3),
    tuning = Grid(
            goal = nothing,
            resolution = 3,
            shuffle = true,
            rng = Random._GLOBAL_RNG()),
    resampling = CV(
            nfolds = 6,
            shuffle = false,
            rng = Random._GLOBAL_RNG()),
    measure = RootMeanSquaredLogError(),
    weights = nothing,
    operation = nothing,
    range = MLJBase.NumericRange{T, MLJBase.Bounded, Symbol} where T[NumericRange(2 ≤ knn_model.K ≤ 100; origin=51.0, unit=49.0) on log10 scale, NumericRange(0.0001 ≤ ridge_model.lambda ≤ 10; origin=5.00005, unit=4.99995) on log10 scale, NumericRange(0.1 ≤ knn_weight ≤ 0.9; origin=0.5, unit=0.4)],
    selection_heuristic = MLJTuning.NaiveSelection(nothing),
    train_best = true,
    repeats = 1,
    n = nothing,
    acceleration = ComputationalResources.CPU1{Nothing}(nothing),
    acceleration_resampling = ComputationalResources.CPU1{Nothing}(nothing),
    check_measure = true,
    cache = true)