Node{Machine{UnivariateBoxCoxTransformer,…}} @748
  args:
    1:	Node{Machine{RidgeRegressor,…}} @045
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…} @596, 
        predict(
            Machine{RidgeRegressor,…} @355, 
            transform(
                Machine{Standardizer,…} @439, 
                Source @715)))