Node{Machine{UnivariateBoxCoxTransformer}} @037
  args:
    1:	Node{Machine{RidgeRegressor}} @093
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @607, 
        predict(
            Machine{RidgeRegressor} @208, 
            transform(
                Machine{Standardizer} @996, 
                Source @834)))