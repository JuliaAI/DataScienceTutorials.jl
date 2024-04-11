Node @324 → LinearRegressor(…)
  args:
    1:	Node @250
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @671),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @671))))