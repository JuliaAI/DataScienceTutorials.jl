Node{Machine{UnivariateBoxCoxTransformer}} @907
  args:
    1:	Node{Machine{RidgeRegressor}} @246
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @796, 
        predict(
            Machine{RidgeRegressor} @255, 
            transform(
                Machine{Standardizer} @356, 
                Source @779)))