ProbabilisticIteratedModel(
  model = ProbabilisticPipeline(
        continuous_encoder = ContinuousEncoder(drop_last = false, …), 
        feature_selector = FeatureSelector(features = [Symbol("Contract__One year"), :StreamingMovies__No, :OnlineBackup__Yes, :OnlineSecurity__Yes, :InternetService__DSL, :DeviceProtection__Yes, :StreamingTV__Yes, Symbol("OnlineSecurity__No internet service"), :Dependents__Yes, :Partner__Yes, :PaperlessBilling__Yes, Symbol("OnlineBackup__No internet service"), :InternetService__No, :StreamingMovies__Yes, :gender__Male, :PhoneService__Yes, Symbol("DeviceProtection__No internet service"), Symbol("StreamingTV__No internet service"), Symbol("StreamingMovies__No internet service"), Symbol("TechSupport__No internet service"), Symbol("MultipleLines__No phone service")], …), 
        evo_tree_classifier = EvoTrees.EvoTreeClassifier{EvoTrees.MLogLoss}
 - nrounds: 100
 - L2: 0.0
 - lambda: 0.0
 - gamma: 0.0
 - eta: 0.1
 - max_depth: 6
 - min_weight: 1.0
 - rowsample: 1.0
 - colsample: 1.0
 - nbins: 64
 - alpha: 0.5
 - tree_type: binary
 - rng: Random.MersenneTwister(123, (0, 236472, 235470, 635))
, 
        cache = true), 
  controls = Any[IterationControl.Step(1), EarlyStopping.NumberSinceBest(4), EarlyStopping.TimeLimit(Dates.Millisecond(2000)), EarlyStopping.InvalidValue()], 
  resampling = Holdout(
        fraction_train = 0.7, 
        shuffle = false, 
        rng = Random._GLOBAL_RNG()), 
  measure = BrierLoss(), 
  weights = nothing, 
  class_weights = nothing, 
  operation = MLJModelInterface.predict, 
  retrain = false, 
  check_measure = true, 
  iteration_parameter = nothing, 
  cache = true)