Node @877 → LinearRegressor(…)
  args:
    1:	Node @613
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @238),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @238))))