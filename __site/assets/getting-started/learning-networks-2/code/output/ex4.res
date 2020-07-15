Node{Machine{RidgeRegressor}} @670
  args:
    1:	Node{Machine{Standardizer}} @385
    predict(
        Machine{RidgeRegressor} @996, 
        transform(
            Machine{Standardizer} @563, 
            Source @695))