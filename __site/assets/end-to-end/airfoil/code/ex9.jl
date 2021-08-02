# This file was generated, do not modify it. # hide
DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree

dcrm = machine(DecisionTreeRegressor(), X, y)

fit!(dcrm, rows=train)
pred_dcrm = predict(dcrm, rows=test);