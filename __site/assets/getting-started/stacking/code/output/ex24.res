Node{Machine{LinearRegressor}} @254
  args:
    1:	Node{Nothing} @040
    predict(
        Machine{LinearRegressor} @092, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @104, 
                    Source @900),
                predict(
                    Machine{KNNRegressor} @659, 
                    Source @900))))