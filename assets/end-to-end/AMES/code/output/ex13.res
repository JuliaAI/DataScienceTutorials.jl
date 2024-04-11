Node @045 → RidgeRegressor(…)
  args:
    1:	Node @922 → OneHotEncoder(…)
  formula:
    predict(
      machine(RidgeRegressor(lambda = 2.5, …), …), 
      transform(
        machine(OneHotEncoder(features = Symbol[], …), …), 
        Source @109))