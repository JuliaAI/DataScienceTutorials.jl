DeterministicTunedModel(
    model = KNNRidgeBlend(
            knn_model = KNNRegressor @150,
            ridge_model = RidgeRegressor @402,
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
    measure = rmsl(),
    weights = nothing,
    operation = MLJModelInterface.predict,
    range = MLJBase.NumericRange{T,MLJBase.Bounded,Symbol} where T[NumericRange{Int64,…} @660, NumericRange{Float64,…} @133, NumericRange{Float64,…} @136],
    train_best = true,
    repeats = 1,
    n = nothing,
    acceleration = CPU1{Nothing}(nothing),
    acceleration_resampling = CPU1{Nothing}(nothing),
    check_measure = true) @774