Node{Machine{LinearRegressor}} @218
  args:
    1:	Node{Nothing} @405
    predict(
        Machine{LinearRegressor} @337, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @576, 
                    Source @048),
                predict(
                    Machine{KNNRegressor} @758, 
                    Source @048))))