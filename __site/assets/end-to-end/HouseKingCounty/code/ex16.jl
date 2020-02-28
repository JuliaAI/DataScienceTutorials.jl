# This file was generated, do not modify it. # hide
rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], predict(rf, rows=test))