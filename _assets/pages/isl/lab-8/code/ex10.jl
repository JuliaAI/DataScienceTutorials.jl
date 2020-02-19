# This file was generated, do not modify it. # hide
X = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))

dtr_model = DecisionTreeRegressor()
dtr = machine(dtr_model, X, y)

fit!(dtr, rows=train)

ypred = predict(dtr, rows=test)
round(rms(ypred, y[test]), sigdigits=3)