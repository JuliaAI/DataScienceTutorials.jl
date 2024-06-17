Node @915 → LinearRegressor(…)
  args:
    1:	Node @841
  formula:
    predict(
      machine(LinearRegressor(fit_intercept = true, …), …), 
      table(
        hcat(
          predict(
            machine(LinearRegressor(fit_intercept = true, …), …), 
            Source @516),
          predict(
            machine(KNNRegressor(K = 5, …), …), 
            Source @516))))