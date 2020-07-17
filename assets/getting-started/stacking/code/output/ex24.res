Node{Machine{LinearRegressor}} @192
  args:
    1:	Node{Nothing} @902
  formula:
    predict(
        Machine{LinearRegressor} @483, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor} @768, 
                    Source @279),
                predict(
                    Machine{KNNRegressor} @479, 
                    Source @279))))