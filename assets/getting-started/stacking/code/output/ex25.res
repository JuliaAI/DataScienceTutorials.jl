Node @623 → LinearRegressor(…)
  args:
    1:	Node @887
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @177),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @177))))