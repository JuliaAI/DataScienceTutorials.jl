# This file was generated, do not modify it. # hide
RFR = @load RandomForestRegressor pkg=MLJScikitLearnInterface

rf_mdl = RFR()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

ypred = MLJ.predict(rf, rows=test)
round(rms(ypred, y[test]), sigdigits=3)