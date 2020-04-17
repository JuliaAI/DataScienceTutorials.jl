# This file was generated, do not modify it. # hide
dcr = @load DecisionTreeRegressor pkg=DecisionTree

dcrm = machine(dcr, X, y)

fit!(dcrm, rows=train, force=true)
pred_dcrm = MLJ.predict(dcrm, rows=test);