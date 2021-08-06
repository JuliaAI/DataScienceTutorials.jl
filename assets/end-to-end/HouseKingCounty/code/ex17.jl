# This file was generated, do not modify it. # hide
rf_mdl = RFR()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

rms(y[test], MLJ.predict(rf, rows=test))