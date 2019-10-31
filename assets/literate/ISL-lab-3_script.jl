# This file was generated, do not modify it.

using MLJ

@load LinearRegressor pkg=MLJLinearModels

using RDatasets, DataFrames
boston = dataset("MASS", "Boston")
first(boston, 3)

describe(boston, :mean, :std, :eltype)

using ScientificTypes
data = coerce(boston, :Tax=>Continuous, :Rad=>Continuous);

y = data.MedV
X = select(data, Not(:MedV));

mdl = LinearRegressor()

mach = machine(mdl, X, y)
fit!(mach)

fp = fitted_params(mach)
@show round.(fp.coefs[1:3], sigdigits=3)
@show round(fp.intercept, sigdigits=3)

ŷ = predict(mach, X)
round(rms(ŷ, y), sigdigits=4)

X2 = hcat(X, X.LStat .* X.Age);

rename!(X2, :x1 => :interaction);

mach = machine(mdl, X2, y)
fit!(mach)
ŷ = predict(mach, X2)
round(rms(ŷ, y), sigdigits=4)

X3 = hcat(X.LStat, X.LStat.^2)
machine(mdl, X3, y)
fit!(mach)
ŷ = predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)

