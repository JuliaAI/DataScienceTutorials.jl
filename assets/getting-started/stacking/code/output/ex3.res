Node{Nothing} @529
  args:
    1:	Node{Nothing} @295
    2:	Node{Nothing} @915
  formula:
    +(
        #118(
            predict(
                Machine{LinearRegressor} @039, 
                Source @886)),
        #118(
            predict(
                Machine{KNNRegressor} @573, 
                Source @886)))