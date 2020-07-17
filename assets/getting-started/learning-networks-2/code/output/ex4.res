Node{Machine{RidgeRegressor}} @733
  args:
    1:	Node{Machine{Standardizer}} @173
  formula:
    predict(
        Machine{RidgeRegressor} @783, 
        transform(
            Machine{Standardizer} @826, 
            Source @104))