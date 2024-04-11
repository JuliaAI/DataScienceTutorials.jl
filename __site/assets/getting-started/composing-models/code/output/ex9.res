DeterministicPipeline(
  f = Main.FD_SANDBOX_11083188621274373481.var"#1#2"(), 
  one_hot_encoder = OneHotEncoder(
        features = Symbol[], 
        drop_last = false, 
        ordered_factor = true, 
        ignore = false), 
  transformed_target_model_deterministic = TransformedTargetModelDeterministic(
        model = RidgeRegressor(lambda = 1.0, …), 
        transformer = UnivariateBoxCoxTransformer(n = 171, …), 
        inverse = nothing, 
        cache = true), 
  cache = true)