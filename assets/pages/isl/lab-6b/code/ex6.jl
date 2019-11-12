# This file was generated, do not modify it. # hide
model.reg = RidgeRegressor()
pipe2 = machine(model, Xc, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)