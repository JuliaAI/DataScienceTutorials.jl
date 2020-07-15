Node{Machine{UnivariateBoxCoxTransformer}} @864
  args:
    1:	Node{Machine{RidgeRegressor}} @530
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @045, 
        predict(
            Machine{RidgeRegressor} @897, 
            transform(
                Machine{Standardizer} @973, 
                Source @198)))