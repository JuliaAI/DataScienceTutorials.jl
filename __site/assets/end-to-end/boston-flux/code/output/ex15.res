DeterministicTunedModel(
    model = NeuralNetworkRegressor(
            builder = MyNetworkBuilder @079,
            optimiser = Flux.Optimise.ADAM(0.001, (0.9, 0.999), IdDict{Any, Any}()),
            loss = Flux.Losses.mse,
            epochs = 15,
            batch_size = 2,
            lambda = 0.0,
            alpha = 0.0,
            rng = Random._GLOBAL_RNG(),
            optimiser_changes_trigger_retraining = false,
            acceleration = ComputationalResources.CPU1{Nothing}(nothing)),
    tuning = Grid(
            goal = nothing,
            resolution = 10,
            shuffle = true,
            rng = Random._GLOBAL_RNG()),
    resampling = Holdout(
            fraction_train = 0.7,
            shuffle = false,
            rng = Random._GLOBAL_RNG()),
    measure = LPLoss(
            p = 2),
    weights = nothing,
    operation = MLJModelInterface.predict,
    range = MLJBase.NumericRange{Int64, MLJBase.Bounded, Symbol}[NumericRange{Int64,…} @083],
    selection_heuristic = MLJTuning.NaiveSelection(nothing),
    train_best = true,
    repeats = 1,
    n = nothing,
    acceleration = ComputationalResources.CPU1{Nothing}(nothing),
    acceleration_resampling = ComputationalResources.CPU1{Nothing}(nothing),
    check_measure = true,
    cache = true) @033