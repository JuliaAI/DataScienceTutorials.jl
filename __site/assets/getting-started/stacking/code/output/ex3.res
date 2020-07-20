Node{Nothing} @270
  args:
    1:	Node{Nothing} @250
    2:	Node{Nothing} @059
  formula:
    +(
        #118(
            predict(
                Machine{LinearRegressor} @329, 
                Source @080)),
        #118(
            predict(
                Machine{KNNRegressor} @952, 
                Source @080)))