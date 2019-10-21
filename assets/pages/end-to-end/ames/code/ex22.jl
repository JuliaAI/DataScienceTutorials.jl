# This file was generated, do not modify it. # hide
krb = KNNRidgeBlend(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(krb, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(y[test], preds)