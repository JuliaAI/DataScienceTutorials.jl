# This file was generated, do not modify it. # hide
XGBR = @load XGBoostRegressor

xgb_mdl = XGBR(num_round=10, max_depth=10)
xgb = machine(xgb_mdl, X, y)
fit!(xgb, rows=train)

ypred = MLJ.predict(xgb, rows=test)
round(rms(ypred, y[test]), sigdigits=3)