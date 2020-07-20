Node{Machine{UnivariateBoxCoxTransformer}} @232
  args:
    1:	Node{Machine{RidgeRegressor}} @615
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @763, 
        predict(
            Machine{RidgeRegressor} @400, 
            transform(
                Machine{Standardizer} @820, 
                Source @483)))