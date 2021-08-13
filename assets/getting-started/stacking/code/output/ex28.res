Node{Machine{LinearRegressor,…}} @580
  args:
    1:	Node{Nothing} @804
  formula:
    predict(
        Machine{LinearRegressor,…} @838, 
        table(
            hcat(
                predict(
                    Machine{LinearRegressor,…} @595, 
                    Source @518),
                predict(
                    Machine{KNNRegressor,…} @930, 
                    Source @518))))