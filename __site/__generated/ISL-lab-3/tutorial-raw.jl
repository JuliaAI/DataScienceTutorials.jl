# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-3/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-3/Manifest.toml).
# For instance, copy these files to a folder 'ISL-lab-3', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/ISL-lab-3/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ


LinearRegressor = @load LinearRegressor pkg=MLJLinearModels

import RDatasets: dataset
import DataFrames: describe, select, Not, rename!
boston = dataset("MASS", "Boston")
first(boston, 3)

describe(boston, :mean, :std, :eltype)

data = coerce(boston, autotype(boston, :discrete_to_continuous));

y = data.MedV
X = select(data, Not(:MedV));

mdl = LinearRegressor()

X_uni = select(X, :LStat) # only a single feature
mach_uni = machine(mdl, X_uni, y)
fit!(mach_uni)

fp = fitted_params(mach_uni)
@show fp.coefs
@show fp.intercept

using PyPlot


figure(figsize=(8,6))
plot(X.LStat, y, ls="none", marker="o")
Xnew = (LStat = collect(range(extrema(X.LStat)..., length=100)),)
plot(Xnew.LStat, MLJ.predict(mach_uni, Xnew))



mach = machine(mdl, X, y)
fit!(mach)

fp = fitted_params(mach)
coefs = fp.coefs
intercept = fp.intercept
for (name, val) in coefs
    println("$(rpad(name, 8)):  $(round(val, sigdigits=3))")
end
println("Intercept: $(round(intercept, sigdigits=3))")

ŷ = MLJ.predict(mach, X)
round(rms(ŷ, y), sigdigits=4)

figure(figsize=(8,6))
res = ŷ .- y
stem(res)



figure(figsize=(8,6))
hist(res, density=true)



X2 = hcat(X, X.LStat .* X.Age);

rename!(X2, :x1 => :interaction);

mach = machine(mdl, X2, y)
fit!(mach)
ŷ = MLJ.predict(mach, X2)
round(rms(ŷ, y), sigdigits=4)

X3 = hcat(X.LStat, X.LStat.^2)
mach = machine(mdl, X3, y)
fit!(mach)
ŷ = MLJ.predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)

Xnew = (LStat = Xnew.LStat, LStat2 = Xnew.LStat.^2)

figure(figsize=(8,6))
plot(X.LStat, y, ls="none", marker="o")
plot(Xnew.LStat, MLJ.predict(mach, Xnew))





# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

