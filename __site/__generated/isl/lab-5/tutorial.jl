# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/isl/lab-5/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/isl/lab-5/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# @@dropdown
# ## Getting started
# @@
# @@dropdown-content

using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select
auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG))
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

# Note the use of `rng=` to seed the shuffling of indices so that the results are reproducible.

# @@dropdown
# ### Polynomial regression
# @@
# @@dropdown-content

LR = @load LinearRegressor pkg=MLJLinearModels

# In this part we only build models with the `Horsepower` feature.

using Plots

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
xlabel!("Horsepower")
ylabel!("MPG")

# \figalt{MPG v Horsepower}{ISL-lab-5-g1.svg}

# Let's get a baseline:

lm = LR()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(MLJ.predict(mlm, rows=test), y[test])^2

# Note that we square the measure to  match the results obtained in the ISL labs where the mean squared error (here we use the `rms` which is the square root of that).

xx = (Horsepower=range(50, 225, length=100) |> collect, )
yy = MLJ.predict(mlm, xx)

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
plot!(xx.Horsepower, yy,  legend=false, linewidth=3, color=:orange)
xlabel!("Horsepower")
ylabel!("MPG")

# \figalt{1st order baseline}{ISL-lab-5-g2.svg}

# We now want to build three polynomial models of degree 1, 2 and 3 respectively; we start by forming the corresponding feature matrix:

hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3);

# Now we  can write a simple pipeline where the first step selects the features we want (and with it the degree of the polynomial) and the second is the linear regressor:

LinMod = Pipeline(
    FeatureSelector(features=[:hp1]),
    LR()
);

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

plot(X.Horsepower, y, seriestype=:scatter, label=false,  size=(800,600))
plot!(xx.Horsepower, yy1,  label="Order 1", linewidth=3, color=:orange,)
plot!(xx.Horsepower, yy2,  label="Order 2", linewidth=3, color=:green,)
plot!(xx.Horsepower, yy3,  label="Order 3", linewidth=3, color=:red,)

xlabel!("Horsepower")
ylabel!("MPG")

# \figalt{1st, 2nd and 3d order fit}{ISL-lab-5-g3.svg}

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## K-Folds Cross Validation
# @@
# @@dropdown-content
#
# Let's crossvalidate over the degree of the  polynomial.
#
# **Note**: there's a  bit of gymnastics here because MLJ doesn't directly support a polynomial regression; see our tutorial on [tuning models](/getting-started/model-tuning/) for a gentler introduction to model tuning.
# The gist of the following code is to create a dataframe where each column is a power of the `Horsepower` feature from 1 to 10 and we build a series of regression models using incrementally more of those features (higher degree):

Xhp = DataFrame([hp.^i for i in 1:10], :auto)

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

# So the conclusion here is that the 5th order polynomial does quite well.
#
# In ISL they use a different seed so the results are a bit different but comparable.

Xnew = DataFrame([hpn.^i for i in 1:10], :auto)
yy5 = MLJ.predict(mtm, Xnew)

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
plot!(xx.Horsepower, yy5, color=:orange, linewidth=4, legend=false)
xlabel!("Horsepower")
ylabel!("MPG")

# \figalt{5th order fit}{ISL-lab-5-g4.svg}

# ‎
# @@
# @@dropdown
# ## The Bootstrap
# @@
# @@dropdown-content
#
# _Bootstrapping is not currently supported in MLJ._

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
