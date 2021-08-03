Node{Machine{UnivariateBoxCoxTransformer,…}} @413
  args:
    1:	Node{Machine{RidgeRegressor,…}} @667
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…} @297, 
        predict(
            Machine{RidgeRegressor,…} @477, 
            transform(
                Machine{Standardizer,…} @795, 
                Source @699)))