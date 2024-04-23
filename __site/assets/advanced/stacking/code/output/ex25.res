Node @146 → LinearRegressor(…)
  args:
    1:	Node @398
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @305),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @305))))