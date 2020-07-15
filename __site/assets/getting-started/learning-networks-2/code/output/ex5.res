Node{Machine{UnivariateBoxCoxTransformer}} @085
  args:
    1:	Node{Machine{RidgeRegressor}} @670
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @675, 
        predict(
            Machine{RidgeRegressor} @996, 
            transform(
                Machine{Standardizer} @563, 
                Source @695)))