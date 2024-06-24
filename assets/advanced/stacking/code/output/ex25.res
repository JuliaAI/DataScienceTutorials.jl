Node @949 → LinearRegressor(…)
  args:
    1:	Node @191
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @176),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @176))))