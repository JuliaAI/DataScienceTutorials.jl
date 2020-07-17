Node{Machine{UnivariateBoxCoxTransformer}} @752
  args:
    1:	Node{Machine{RidgeRegressor}} @899
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @989, 
        predict(
            Machine{RidgeRegressor} @541, 
            transform(
                Machine{Standardizer} @163, 
                Source @158)))