# ## Getting started

using MLJ, RDatasets

auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);

# Note the use of `rng=` to seed the shuffling of indices so that the results are reproducible.

# ### Polynomial regression
#

@load LinearRegressor pkg=MLJLinearModels

# In this part we only build models with the Horsepower feature.
# Let's get a baseline:

lm = LinearRegressor()
mlm = machine(lm, select(X, :Horsepower), y)
fit!(mlm, rows=train)
rms(predict(mlm, rows=test), y[test])^2

# Note that we square the measure to  match the results obtained in the ISL labs where the mean squared error (here we use the `rms` which is the square root of that).
#
# We now want to build three polynomial models of degree 1, 2 and 3 respectively; we start by forming the corresponding feature matrix:

hp = X.Horsepower
Xhp = DataFrame(hp1=hp, hp2=hp.^2, hp3=hp.^3)

# Now we  can write a simple pipeline where the first step selects the features we want (and with it the degree of the polynomial) and the second is the linear regressor:

@pipeline LinMod(fs = FeatureSelector(features=[:hp1]),
                 lr = LinearRegressor())

# Then we can  instantiate and fit 3 models where we specify the features each time:

lrm = LinMod()
lr1 = machine(lrm, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

lrm.fs.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(lrm, Xhp, y)
fit!(lr2, rows=train)

lrm.fs.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(lrm, Xhp, y)
fit!(lr3, rows=train)

# Let's check the performances on the test set

@show rms(lr1)^2
@show rms(lr2)^2
@show rms(lr3)^2

# ## K-Folds Cross Validation
#
# Let's crossvalidate over the degree of the  polynomial.
# **Note**: there's a  bit of gymnastics here because MLJ doesn't directly support a polynomial regression; see our tutorial on [tuning models](/pub/getting-started/model-tuning.html).

Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(lrm, :(fs.features), values=cases)

tm = TunedModel(model=lrm, ranges=r, resampling=CV(nfolds=10), measure=rms)

# Now we're left with fitting the tuned model

mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)
@show round.(rep.measurements.^2, digits=2)
@show argmin(rep.measurements)

#
# So the conclusion here is that the 5th order polynomial does quite well.
#
# In ISL they use a different seed so the results are a bit different but comparable.

# ## The Bootstrap
#
# _Bootstrapping is not currently supported in MLJ._
