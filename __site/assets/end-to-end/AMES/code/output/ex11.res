Node{Machine{KNNRegressor}} @693
  args:
    1:	Node{Machine{OneHotEncoder}} @697
  formula:
    predict(
        Machine{KNNRegressor} @803, 
        transform(
            Machine{OneHotEncoder} @182, 
            Source @691))