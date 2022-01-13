Node{Machine{UnivariateBoxCoxTransformer,…}}
  args:
    1:	Node{Machine{RidgeRegressor,…}}
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…}, 
        predict(
            Machine{RidgeRegressor,…}, 
            transform(
                Machine{Standardizer,…}, 
                Source @276)))