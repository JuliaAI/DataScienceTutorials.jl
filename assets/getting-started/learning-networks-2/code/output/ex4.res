Node{Machine{RidgeRegressor}} @601
  args:
    1:	Node{Machine{Standardizer}} @809
  formula:
    predict(
        Machine{RidgeRegressor} @916, 
        transform(
            Machine{Standardizer} @541, 
            Source @488))