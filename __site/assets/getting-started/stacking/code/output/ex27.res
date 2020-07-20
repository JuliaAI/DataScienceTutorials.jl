Node{Machine{LinearRegressor}} @693
  args:
    1:	Node{Nothing} @951
  formula:
    predict(
        Machine{LinearRegressor} @724, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @691, 
                    Source @478),
                predict(
                    Machine{KNNRegressor} @714, 
                    Source @478))))