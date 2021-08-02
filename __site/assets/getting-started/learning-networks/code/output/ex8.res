Node{Machine{UnivariateBoxCoxTransformer,…}} @322
  args:
    1:	Node{Machine{RidgeRegressor,…}} @886
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…} @117, 
        predict(
            Machine{RidgeRegressor,…} @977, 
            transform(
                Machine{Standardizer,…} @706, 
                Source @877)))