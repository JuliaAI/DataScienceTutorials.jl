Node @508 → RidgeRegressor(…)
  args:
    1:	Node @395 → OneHotEncoder(…)
  formula:
    predict(
      machine(RidgeRegressor(lambda = 2.5, …), …), 
      transform(
        machine(OneHotEncoder(features = Symbol[], …), …), 
        Source @706))