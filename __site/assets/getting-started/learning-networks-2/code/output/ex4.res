Node{Machine{RidgeRegressor}} @064
  args:
    1:	Node{Machine{Standardizer}} @070
  formula:
    predict(
        Machine{RidgeRegressor} @310, 
        transform(
            Machine{Standardizer} @498, 
            Source @912))