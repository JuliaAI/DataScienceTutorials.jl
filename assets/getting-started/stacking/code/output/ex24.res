Node{Machine{LinearRegressor}} @373
  args:
    1:	Node{Nothing} @911
  formula:
    predict(
        Machine{LinearRegressor} @888, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @212, 
                    Source @471),
                predict(
                    Machine{KNNRegressor} @370, 
                    Source @471))))