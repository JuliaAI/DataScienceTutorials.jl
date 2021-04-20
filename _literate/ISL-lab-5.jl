# ## Getting started

using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select
MLJ.color_off() # hide
auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

# Note the use of `rng=` to seed the shuffling of indices so that the results are reproducible.

# ### Polynomial regression
#

LR = @load LinearRegressor pkg=MLJLinearModels

# In this part we only build models with the `Horsepower` feature.

using PyPlot
ioff() # hide

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-5-g1.svg")) # hide

# \figalt{MPG v Horsepower}{ISL-lab-5-g1.svg}

# Let's get a baseline:

lm = LR()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(MLJ.predict(mlm, rows=test), y[test])^2

# Note that we square the measure to  match the results obtained in the ISL labs where the mean squared error (here we use the `rms` which is the square root of that).

xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = MLJ.predict(mlm, xx)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-5-g2.svg")) # hide

# \figalt{1st order baseline}{ISL-lab-5-g2.svg}

# We now want to build three polynomial models of degree 1, 2 and 3 respectively; we start by forming the corresponding feature matrix:

hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3);

# Now we  can write a simple pipeline where the first step selects the features we want (and with it the degree of the polynomial) and the second is the linear regressor:

LinMod = @pipeline(FeatureSelector(features=[:hp1]),
                   LinearRegressor());

# Then we can  instantiate and fit 3 models where we specify the features each time:

lr1 = machine(LinMod, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

LinMod.feature_selector.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(LinMod, Xhp, y)
fit!(lr2, rows=train)

LinMod.feature_selector.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(LinMod, Xhp, y)
fit!(lr3, rows=train)

# Let's check the performances on the test set

get_mse(lr) = rms(MLJ.predict(lr, rows=test), y[test])^2

@show get_mse(lr1)
@show get_mse(lr2)
@show get_mse(lr3)

# Let's visualise the models

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

savefig(joinpath(@OUTPUT, "ISL-lab-5-g3.svg")) # hide

# \figalt{1st, 2nd and 3d order fit}{ISL-lab-5-g3.svg}

# ## K-Folds Cross Validation
#
# Let's crossvalidate over the degree of the  polynomial.
#
# **Note**: there's a  bit of gymnastics here because MLJ doesn't directly support a polynomial regression; see our tutorial on [tuning models](/getting-started/model-tuning/) for a gentler introduction to model tuning.
# The gist of the following code is to create a dataframe where each column is a power of the `Horsepower` feature from 1 to 10 and we build a series of regression models using incrementally more of those features (higher degree):

Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(LinMod, :(feature_selector.features), values=cases)

tm = TunedModel(model=LinMod, ranges=r, resampling=CV(nfolds=10), measure=rms)

# Now we're left with fitting the tuned model

mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)

res = rep.plotting

@show round.(res.measurements.^2, digits=2)
@show argmin(res.measurements)

#
# So the conclusion here is that the 5th order polynomial does quite well.
#
# In ISL they use a different seed so the results are a bit different but comparable.
#

Xnew = DataFrame([hpn.^i for i in 1:10])
yy5 = MLJ.predict(mtm, Xnew)

figure(figsize=(8,6))
plot(X.Horsepower, y, ls="none", marker="o")
plot(xx.Horsepower, yy5, lw=3)

xlabel("Horsepower", fontsize=14)
xticks(50:50:250, fontsize=12)
yticks(10:10:50, fontsize=12)
ylabel("MPG", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-5-g4.svg")) # hide

# \figalt{5th order fit}{ISL-lab-5-g4.svg}

# ## The Bootstrap
#
# _Bootstrapping is not currently supported in MLJ._
PyPlot.close_figs() # hide
