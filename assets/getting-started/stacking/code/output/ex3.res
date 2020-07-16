Node{Nothing} @400
  args:
    1:	Node{Nothing} @558
    2:	Node{Nothing} @673
    +(
        #118(
            predict(
                Machine{LinearRegressor} @832, 
                Source @444)),
        #118(
            predict(
                Machine{KNNRegressor} @431, 
                Source @444)))