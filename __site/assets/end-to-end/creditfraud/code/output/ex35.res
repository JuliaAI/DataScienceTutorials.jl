ProbabilisticPipeline(
  standardizer = Standardizer(
        features = Symbol[], 
        ignore = false, 
        ordered_factor = false, 
        count = false), 
  balanced_model_probabilistic = BalancedModelProbabilistic(
        model = NeuralNetworkClassifier(builder = GenericBuilder(apply = #1), …), 
        oversampler = SMOTE(k = 5, …)), 
  cache = true)