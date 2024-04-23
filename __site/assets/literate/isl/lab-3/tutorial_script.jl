# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/isl/lab-3/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
MLJ.color_off() # hide

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

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.3) #hide

plot(X.LStat, y, seriestype=:scatter, markershape=:circle, legend=false, size=(800,600))

Xnew = (LStat = collect(range(extrema(X.LStat)..., length=100)),)
plot!(Xnew.LStat, MLJ.predict(mach_uni, Xnew), linewidth=3, color=:orange)

savefig(joinpath(@OUTPUT, "ISL-lab-3-lm1.svg")); # hide

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

res = ŷ .- y
plot(res, line=:stem, linewidth=1, marker=:circle, legend=false, size=((800,600)))
hline!([0], linewidth=2, color=:red)    # add a horizontal line at x=0
savefig(joinpath(@OUTPUT, "ISL-lab-3-res.svg")); # hide

histogram(res, normalize=true, size=(800,600), label="residual")

savefig(joinpath(@OUTPUT, "ISL-lab-3-res2.svg")); # hide

X2 = hcat(X, X.LStat .* X.Age);

rename!(X2, :x1 => :interaction);

mach = machine(mdl, X2, y)
fit!(mach)
ŷ = MLJ.predict(mach, X2)
round(rms(ŷ, y), sigdigits=4)

X3 = hcat(X.LStat, X.LStat.^2) |> MLJ.table
mach = machine(mdl, X3, y)
fit!(mach)
ŷ = MLJ.predict(mach, X3)
round(rms(ŷ, y), sigdigits=4)

Xnew = (LStat = Xnew.LStat, LStat2 = Xnew.LStat.^2)

plot(X.LStat, y, seriestype=:scatter, markershape=:circle, legend=false, size=(800,600))
plot!(Xnew.LStat, MLJ.predict(mach, Xnew), linewidth=3, color=:orange)

savefig(joinpath(@OUTPUT, "ISL-lab-3-lreg.svg")); # hide
