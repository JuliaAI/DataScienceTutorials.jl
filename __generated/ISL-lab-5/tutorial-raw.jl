# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-5/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-5/Manifest.toml).
# For instance, copy these files to a folder 'ISL-lab-5', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/ISL-lab-5/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select

auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

LR = @load LinearRegressor pkg=MLJLinearModels

using PyPlot


figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)



lm = LR()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(MLJ.predict(mlm, rows=test), y[test])^2

xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = MLJ.predict(mlm, xx)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)



hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3);

LinMod = @pipeline(FeatureSelector(features=[:hp1]),
                   LR());

lr1 = machine(LinMod, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

LinMod.feature_selector.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(LinMod, Xhp, y)
fit!(lr2, rows=train)

LinMod.feature_selector.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(LinMod, Xhp, y)
fit!(lr3, rows=train)

get_mse(lr) = rms(MLJ.predict(lr, rows=test), y[test])^2

@show get_mse(lr1)
@show get_mse(lr2)
@show get_mse(lr3)

hpn  = xx.Horsepower
Xnew = DataFrame(hp1=hpn, hp2=hpn.^2, hp3=hpn.^3)

yy1 = MLJ.predict(lr1, Xnew)
yy2 = MLJ.predict(lr2, Xnew)
yy3 = MLJ.predict(lr3, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy1, lw=3, label="Order 1")
plot(xx.Horsepower, yy2, lw=3, label="Order 2")
plot(xx.Horsepower, yy3, lw=3, label="Order 3")

legend(fontsize=14)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)



Xhp = DataFrame([hp.^i for i in 1:10], :auto)

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(LinMod, :(feature_selector.features), values=cases)

tm = TunedModel(model=LinMod, ranges=r, resampling=CV(nfolds=10), measure=rms)

mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)

res = rep.plotting

@show round.(res.measurements.^2, digits=2)
@show argmin(res.measurements)

Xnew = DataFrame([hpn.^i for i in 1:10], :auto)
yy5 = MLJ.predict(mtm, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy5, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)





# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

