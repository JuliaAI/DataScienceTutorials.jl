# This file was generated, do not modify it.

using MLJ, RDatasets

auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

@load LinearRegressor pkg=MLJLinearModels

lm = LinearRegressor()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(predict(mlm, rows=test), y[test])^2

hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3)

@pipeline LinMod(fs = FeatureSelector(features=[:hp1]),
                 lr = LinearRegressor())

lrm = LinMod()
lr1 = machine(lrm, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

lrm.fs.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(lrm, Xhp, y)
fit!(lr2, rows=train)

lrm.fs.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(lrm, Xhp, y)
fit!(lr3, rows=train)

@show rms(lr1)^2
@show rms(lr2)^2
@show rms(lr3)^2

Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(lrm, :(fs.features), values=cases)

tm = TunedModel(model=lrm, ranges=r, resampling=CV(nfolds=10), measure=rms)

mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)
@show round.(rep.measurements.^2, digits=2)
@show argmin(rep.measurements)

