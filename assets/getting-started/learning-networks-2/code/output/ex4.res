Node{Machine{RidgeRegressor}} @145
  args:
    1:	Node{Machine{Standardizer}} @289
    predict(
        Machine{RidgeRegressor} @247, 
        transform(
            Machine{Standardizer} @412, 
            Source @015))