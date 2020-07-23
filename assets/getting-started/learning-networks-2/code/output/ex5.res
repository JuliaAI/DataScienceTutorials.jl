Node{Machine{UnivariateBoxCoxTransformer}} @605
  args:
    1:	Node{Machine{RidgeRegressor}} @064
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @156, 
        predict(
            Machine{RidgeRegressor} @310, 
            transform(
                Machine{Standardizer} @498, 
                Source @912)))