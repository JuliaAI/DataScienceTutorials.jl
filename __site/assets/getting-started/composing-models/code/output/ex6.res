TransformedTargetModelDeterministic(
  model = RidgeRegressor(
        lambda = 1.0, 
        fit_intercept = true, 
        penalize_intercept = false, 
        scale_penalty_with_samples = true, 
        solver = nothing), 
  transformer = UnivariateBoxCoxTransformer(
        n = 171, 
        shift = false), 
  inverse = nothing, 
  cache = true)