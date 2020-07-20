Node{Machine{UnivariateBoxCoxTransformer}} @709
  args:
    1:	Node{Machine{RidgeRegressor}} @145
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @230, 
        predict(
            Machine{RidgeRegressor} @247, 
            transform(
                Machine{Standardizer} @412, 
                Source @015)))