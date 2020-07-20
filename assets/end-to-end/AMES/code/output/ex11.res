Node{Machine{KNNRegressor}} @873
  args:
    1:	Node{Machine{OneHotEncoder}} @846
  formula:
    predict(
        Machine{KNNRegressor} @456, 
        transform(
            Machine{OneHotEncoder} @746, 
            Source @759))