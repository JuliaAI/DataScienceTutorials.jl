Node{Machine{UnivariateBoxCoxTransformer}} @607
  args:
    1:	Node{Machine{RidgeRegressor}} @733
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @816, 
        predict(
            Machine{RidgeRegressor} @783, 
            transform(
                Machine{Standardizer} @826, 
                Source @104)))