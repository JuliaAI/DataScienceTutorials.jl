# This file was generated, do not modify it. # hide
coerce!(X, Count => Continuous)

xgb  = XGBoostRegressor()
xgbm = machine(xgb, X, y)
fit!(xgbm, rows=train)

rms(y[test], predict(xgbm, rows=test))