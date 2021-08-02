# This file was generated, do not modify it. # hide
@load XGBoostRegressor

xgb_mdl = XGBoostRegressor(num_round=10, max_depth=10)
xgb = machine(xgb_mdl, X, y)
fit!(xgb, rows=train)

ypred = predict(xgb, rows=test)
round(rms(ypred, y[test]), sigdigits=3)