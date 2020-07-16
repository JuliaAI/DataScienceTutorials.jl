Node{Machine{RidgeRegressor}} @246
  args:
    1:	Node{Machine{Standardizer}} @442
  formula:
    predict(
        Machine{RidgeRegressor} @255, 
        transform(
            Machine{Standardizer} @356, 
            Source @779))