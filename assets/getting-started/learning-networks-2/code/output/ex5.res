Node{Machine{UnivariateBoxCoxTransformer}} @862
  args:
    1:	Node{Machine{RidgeRegressor}} @574
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @909, 
        predict(
            Machine{RidgeRegressor} @019, 
            transform(
                Machine{Standardizer} @158, 
                Source @837)))