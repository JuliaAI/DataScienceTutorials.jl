Node{Machine{UnivariateBoxCoxTransformer}} @857
  args:
    1:	Node{Machine{RidgeRegressor}} @291
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer} @359, 
        predict(
            Machine{RidgeRegressor} @843, 
            transform(
                Machine{Standardizer} @080, 
                Source @203)))