# ## Getting started

using MLJ, RDatasets, ScientificTypes, PrettyPrinting

@load LinearRegressor pkg=MLJLinearModels
@load RidgeRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint

# The target is `Salary`

y, X = unpack(hitters, ==(:Salary), col->true);

# It has missing values which we will just ignore:

no_miss = .!ismissing.(y)
y = collect(skipmissing(y))
X = X[no_miss, :]
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=424);

# Most features are currently encoded as integers but we will consider them as continuous

Xc = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))
scitype(Xc)

# There're a few features that are categorical which we'll one-hot-encode.

# ## Ridge pipeline
# ### Baseline
#
# Let's first fit a simple pipeline with a one-hot-encoder and a basic linear regression:

@pipeline HotReg(hot = OneHotEncoder(),
                 reg = LinearRegressor())

model = HotReg()
pipe1 = machine(model, Xc, y)
fit!(pipe1, rows=train)
ŷ = predict(pipe1, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# ### Basic ridge
#
# Let's now swap the linear regressor for a ridge one without specifying the penalty (`1` by default):

model.reg = RidgeRegressor()
pipe2 = machine(model, Xc, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# Ok that's a bit better but not really by a wide margin.

# ### Cross validating

# What penalty should you use? Let's do a simple CV to try  to find out:

r  = range(model, :(reg.lambda), lower=1e-2, upper=1e9, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)

# right, and  with that we get:

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# It's a bit of a case of bad data (and tuning) though, let's remove the categorical features:

Xc2 = select(Xc, Not([:League, :Division, :NewLeague]))
pipe2 = machine(model, Xc2, y)
fit!(pipe2, rows=train)
ŷ = predict(pipe2, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# So here we've done no hyperparameter tuning and already get comparable results, let's re-tune and use proper cross-validation as well

tm.resampling = CV(nfolds=5)
mtm = machine(tm, Xc2, y)
fit!(mtm, rows=train)

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)

# Ok that's better!

#
# _ongoing completion_
#
