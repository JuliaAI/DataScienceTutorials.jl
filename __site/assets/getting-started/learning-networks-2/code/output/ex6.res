Node{Machine{UnivariateBoxCoxTransformer,…}} @087
  args:
    1:	Node{Machine{RidgeRegressor,…}} @195
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…} @082, 
        predict(
            Machine{RidgeRegressor,…} @438, 
            transform(
                Machine{Standardizer,…} @181, 
                Source @174)))