Node{Machine{LinearRegressor}} @307
  args:
    1:	Node{Nothing} @256
    predict(
        Machine{LinearRegressor} @149, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @067, 
                    Source @869),
                predict(
                    Machine{KNNRegressor} @706, 
                    Source @869))))