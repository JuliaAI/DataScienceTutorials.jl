# This file was generated, do not modify it. # hide
model = Standardizer() |>  OneHotEncoder() |> LinearRegressor()

pipe = machine(model, Xc, y)
fit!(pipe, rows = train)
ŷ = MLJ.predict(pipe, rows = test)
round(rms(ŷ, y[test])^2, sigdigits = 4)