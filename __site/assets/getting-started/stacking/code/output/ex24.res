Node{Machine{LinearRegressor}} @718
  args:
    1:	Node{Nothing} @741
    predict(
        Machine{LinearRegressor} @478, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @141, 
                    Source @550),
                predict(
                    Machine{KNNRegressor} @187, 
                    Source @550))))