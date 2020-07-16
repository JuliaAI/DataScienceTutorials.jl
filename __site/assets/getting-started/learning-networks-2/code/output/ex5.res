Node{Machine{UnivariateBoxCoxTransformer}} @509
  args:
    1:	Node{Machine{RidgeRegressor}} @601
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @492, 
        predict(
            Machine{RidgeRegressor} @916, 
            transform(
                Machine{Standardizer} @541, 
                Source @488)))