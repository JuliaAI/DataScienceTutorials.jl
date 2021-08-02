# This file was generated, do not modify it. # hide
@load RandomForestRegressor pkg=ScikitLearn

rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

ypred = predict(rf, rows=test)
round(rms(ypred, y[test]), sigdigits=3)