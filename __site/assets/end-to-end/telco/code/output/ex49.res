ProbabilisticIteratedModel(
  model = ProbabilisticPipeline(
        continuous_encoder = ContinuousEncoder(drop_last = false, …), 
        feature_selector = FeatureSelector(features = [:TechSupport__No, Symbol("PaymentMethod__Credit card (automatic)"), :StreamingMovies__No, Symbol("Contract__One year"), Symbol("Contract__Two year"), :Partner__Yes, :OnlineBackup__No, :Dependents__Yes, :Partner__No, :gender__Male, Symbol("PaymentMethod__Mailed check"), Symbol("OnlineSecurity__No internet service"), :OnlineSecurity__No, Symbol("PaymentMethod__Electronic check"), :OnlineSecurity__Yes, Symbol("InternetService__Fiber optic"), :TechSupport__Yes, Symbol("OnlineBackup__No internet service"), :InternetService__No, :StreamingTV__Yes, :PhoneService__No, :PhoneService__Yes, Symbol("DeviceProtection__No internet service"), Symbol("StreamingTV__No internet service"), Symbol("StreamingMovies__No internet service"), Symbol("TechSupport__No internet service"), :MultipleLines__Yes, Symbol("MultipleLines__No phone service"), :InternetService__DSL], …), 
        evo_tree_classifier = EvoTreeClassifier(loss = EvoTrees.Softmax(), …), 
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