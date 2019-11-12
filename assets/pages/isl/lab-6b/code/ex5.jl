# This file was generated, do not modify it. # hide
@pipeline HotReg(hot = OneHotEncoder(),
                 reg = LinearRegressor())

model = HotReg()
pipe1 = machine(model, Xc, y)
fit!(pipe1, rows=train)
ŷ = predict(pipe1, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)