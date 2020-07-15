Node{Machine{KNNRegressor}} @526
  args:
    1:	Node{Machine{OneHotEncoder}} @335
    predict(
        Machine{KNNRegressor} @552, 
        transform(
            Machine{OneHotEncoder} @569, 
            Source @425))