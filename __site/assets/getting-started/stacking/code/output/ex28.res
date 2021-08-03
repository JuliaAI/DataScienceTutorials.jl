Node{Machine{LinearRegressor,…}} @833
  args:
    1:	Node{Nothing} @971
  formula:
    predict(
        Machine{LinearRegressor,…} @239, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor,…} @522, 
                    Source @251),
                predict(
                    Machine{KNNRegressor,…} @335, 
                    Source @251))))