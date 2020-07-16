# This file was generated, do not modify it.

using MLJ, RDatasets

auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

@load LinearRegressor pkg=MLJLinearModels

using PyPlot

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g1.svg") # hide

lm = LinearRegressor()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(predict(mlm, rows=test), y[test])^2

xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = predict(mlm, xx)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g2.svg") # hide

hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3);

@pipeline LinMod(fs = FeatureSelector(features=[:hp1]),
                 lr = LinearRegressor());

lrm = LinMod()
lr1 = machine(lrm, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

lrm.fs.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(lrm, Xhp, y)
fit!(lr2, rows=train)

lrm.fs.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(lrm, Xhp, y)
fit!(lr3, rows=train)

get_mse(lr) = rms(predict(lr, rows=test), y[test])^2

@show get_mse(lr1)
@show get_mse(lr2)
@show get_mse(lr3)

hpn  = xx.Horsepower
Xnew = DataFrame(hp1=hpn, hp2=hpn.^2, hp3=hpn.^3)

yy1 = predict(lr1, Xnew)
yy2 = predict(lr2, Xnew)
yy3 = predict(lr3, Xnew)

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

savefig("assets/literate/ISL-lab-5-g3.svg") # hide

Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(lrm, :(fs.features), values=cases)

tm = TunedModel(model=lrm, ranges=r, resampling=CV(nfolds=10), measure=rms)

mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)
@show round.(rep.measurements.^2, digits=2)
@show argmin(rep.measurements)

Xnew = DataFrame([hpn.^i for i in 1:10])
yy5 = predict(mtm, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy5, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig("assets/literate/ISL-lab-5-g4.svg") # hide

