Node @270 → LinearRegressor(…)
  args:
    1:	Node @163
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @411),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @411))))