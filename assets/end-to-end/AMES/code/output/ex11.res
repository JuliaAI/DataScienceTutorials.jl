Node{Machine{KNNRegressor}} @645
  args:
    1:	Node{Machine{OneHotEncoder}} @244
  formula:
    predict(
        Machine{KNNRegressor} @791, 
        transform(
            Machine{OneHotEncoder} @890, 
            Source @381))