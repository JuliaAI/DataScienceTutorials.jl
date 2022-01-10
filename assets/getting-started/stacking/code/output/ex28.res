Node{Machine{LinearRegressor,…}}
  args:
    1:	Node{Nothing}
  formula:
    predict(
        Machine{LinearRegressor,…}, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor,…}, 
                    Source @489),
                predict(
                    Machine{KNNRegressor,…}, 
                    Source @489))))