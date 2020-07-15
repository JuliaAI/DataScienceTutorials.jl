Node{Machine{UnivariateBoxCoxTransformer}} @153
  args:
    1:	Node{Machine{RidgeRegressor}} @524
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @934, 
        predict(
            Machine{RidgeRegressor} @365, 
            transform(
                Machine{Standardizer} @421, 
                Source @024)))