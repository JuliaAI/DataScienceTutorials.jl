Node{Machine{RidgeRegressor,…}} @195
  args:
    1:	Node{Machine{Standardizer,…}} @520
  formula:
    predict(
        Machine{RidgeRegressor,…} @438, 
        transform(
            Machine{Standardizer,…} @181, 
            Source @174))