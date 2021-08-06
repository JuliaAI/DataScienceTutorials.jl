Node{Machine{UnivariateBoxCoxTransformer,…}} @830
  args:
    1:	Node{Machine{RidgeRegressor,…}} @246
  formula:
    inverse_transform(
        Machine{UnivariateBoxCoxTransformer,…} @860, 
        predict(
            Machine{RidgeRegressor,…} @646, 
            transform(
                Machine{Standardizer,…} @730, 
                Source @370)))