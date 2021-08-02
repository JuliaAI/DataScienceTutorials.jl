Node{Machine{LinearRegressor,…}} @492
  args:
    1:	Node{Nothing} @938
  formula:
    predict(
        Machine{LinearRegressor,…} @778, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor,…} @850, 
                    Source @255),
                predict(
                    Machine{KNNRegressor,…} @479, 
                    Source @255))))