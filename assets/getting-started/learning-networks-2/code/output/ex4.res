Node{Machine{RidgeRegressor}} @093
  args:
    1:	Node{Machine{Standardizer}} @319
  formula:
    predict(
        Machine{RidgeRegressor} @208, 
        transform(
            Machine{Standardizer} @996, 
            Source @834))