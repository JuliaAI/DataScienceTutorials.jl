DeterministicTunedModel(
    model = Pipeline303(
            feature_selector = FeatureSelector,
            linear_regressor = LinearRegressor),
    tuning = Grid(
            goal = nothing,
            resolution = 10,
            shuffle = true,
            rng = Random._GLOBAL_RNG()),
    resampling = CV(
            nfolds = 10,
            shuffle = false,
            rng = Random._GLOBAL_RNG()),
    measure = RootMeanSquaredError(),
    weights = nothing,
    operation = nothing,
    range = NominalRange(feature_selector.features = [:x1], [:x1, :x2], [:x1, :x2, :x3], ...),
    selection_heuristic = MLJTuning.NaiveSelection(nothing),
    train_best = true,
    repeats = 1,
    n = nothing,
    acceleration = ComputationalResources.CPU1{Nothing}(nothing),
    acceleration_resampling = ComputationalResources.CPU1{Nothing}(nothing),
    check_measure = true,
    cache = true)