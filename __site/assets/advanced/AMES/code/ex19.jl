# This file was generated, do not modify it. # hide
blended = BlendedRegressor(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(blended, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(preds, y[test])