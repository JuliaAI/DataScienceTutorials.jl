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
# Let's first fit a simple pipeline with a standardizer, a one-hot-encoder and a basic linear regression:

@pipeline RegPipe(std = Standardizer(),
                  hot = OneHotEncoder(),
                  reg = LinearRegressor())

model = RegPipe()
pipe  = machine(model, Xc, y)
fit!(pipe, rows=train)
ŷ = predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# ### Basic ridge
#
# Let's now swap the linear regressor for a ridge one without specifying the penalty (`1` by default):

pipe.model.reg = RidgeRegressor()
fit!(pipe, rows=train)
ŷ = predict(pipe, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Ok that's a bit better but surely we can do better with an appropriate selection of the hyperparameter.

# ### Cross validating

# What penalty should you use? Let's do a simple CV to try  to find out:

r  = range(model, :(reg.lambda), lower=1e-2, upper=100_000, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                resampling=CV(nfolds=3, rng=4141), measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.reg.lambda, sigdigits=4)

# right, and  with that we get:

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# ## Lasso pipeline
#
# Let's do the same as above but using a Lasso model and adjusting the range a bit:

mtm.model.model.reg = LassoRegressor()
mtm.model.ranges = range(model, :(reg.lambda), lower=500, upper=100_000, scale=:log10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.reg.lambda, sigdigits=4)

# Ok and let's see how that does:

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# Pretty good! and the parameters are reasonably sparse as expected:

coefs = mtm.fitresult.fitresult.machine.fitresult
round.(coefs, sigdigits=2)

# with around 50% sparsity:

sum(coefs .≈ 0) / length(coefs)

# ## Elastic net pipeline

@load ElasticNetRegressor pkg=MLJLinearModels

mtm.model.model.reg = ElasticNetRegressor()
mtm.model.ranges = [range(model, :(reg.lambda), lower=0.1, upper=100, scale=:log10),
                    range(model, :(reg.gamma),  lower=500, upper=10_000, scale=:log10)]
mtm.model.tuning = Grid(resolution=10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)
@show round(best_mdl.reg.gamma, sigdigits=4)

# And it's not too bad in terms of accuracy either

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test])^2, sigdigits=4)

# But the simple ridge regression seems to work best here.
