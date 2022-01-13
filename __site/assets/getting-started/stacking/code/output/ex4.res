Node{Nothing}
  args:
    1:	Node{Nothing}
    2:	Node{Nothing}
  formula:
    +(
        #100(
            predict(
                Machine{LinearRegressor,…}, 
                Source @196)),
        #100(
            predict(
                Machine{KNNRegressor,…}, 
                Source @196)))