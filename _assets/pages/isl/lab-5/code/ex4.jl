# This file was generated, do not modify it. # hide
lm = LinearRegressor()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(predict(mlm, rows=test), y[test])^2