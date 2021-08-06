# This file was generated, do not modify it. # hide
coerce!(X, Count => Continuous)

xgb  = XGBR()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], MLJ.predict(xgbm, rows=test))