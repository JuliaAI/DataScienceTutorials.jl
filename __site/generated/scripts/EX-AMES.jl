# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Baby steps## Let's load a reduced version of the well-known Ames House Price data set (containing six of the more important categorical features and six of the more important numerical features).# As "iris" the dataset is so common that you can load it directly with `@load_ames` and the reduced version via `@load_reduced_ames`
using MLJ
using  PrettyPrinting
import DataFrames
import Statistics


X, y = @load_reduced_ames
X = DataFrames.DataFrame(X)
@show size(X)
first(X, 3) |> pretty

# and the target is a continuous vector:
@show y[1:3]
scitype(y)

# so this is a standard regression problem with a mix of categorical and continuous input.## ## Dummy model## Remember that a model is just a container for hyperparameters; let's take a particularly simple one: the constant regression.
creg = ConstantRegressor()

# Wrapping the model in data creates a *machine* which will store training outcomes (*fit-results*)
cmach = machine(creg, X, y)

# You can now train the machine specifying the data it should be trained on (if unspecified, all the data will be used);
train, test = partition(eachindex(y), 0.70, shuffle=true); # 70:30 split
fit!(cmach, rows=train)
ŷ = predict(cmach, rows=test)
ŷ[1:3] |> pprint

# Observe that the output is probabilistic, each element is a univariate normal distribution (with the same mean and variance as it's a constant model).## You can recover deterministic output by either computing the mean of predictions or using `predict_mean` directly (the `mean` function can  bve applied to any distribution from [`Distributions.jl`](https://github.com/JuliaStats/Distributions.jl)):
ŷ = predict_mean(cmach, rows=test)
ŷ[1:3]

# You can then call one of the loss functions to assess the quality of the model by comparing the performances on the test set:
rmsl(ŷ, y[test])

# ## KNN-Ridge blend## Let's try something a bit fancier than a constant regressor.## * one-hot-encode categorical inputs# * log-transform the target# * fit both a KNN regression and a Ridge regression on the data# * Compute a weighted average of individual model predictions# * inverse transform (exponentiate) the blended prediction## You will first define a fixed model where all hyperparameters are specified or set to default. Then you will see how to create a model around a learning network that can be tuned.
@load RidgeRegressor pkg="MultivariateStats"
@load KNNRegressor

# ### Using the expanded syntax## Let's start by defining the source nodes:
Xs = source(X)
ys = source(y)

# On the "first layer", there's one hot encoder and a log transform, these will respectively lead to node `W` and node `z`:
hot = machine(OneHotEncoder(), Xs)

W = transform(hot, Xs)
z = log(ys);

# On the "second layer", there's a KNN regressor and a ridge regressor, these lead to node `ẑ₁` and `ẑ₂`
knn   = machine(KNNRegressor(K=5), W, z)
ridge = machine(RidgeRegressor(lambda=2.5), W, z)

ẑ₁ = predict(ridge, W)
ẑ₂ = predict(knn, W)

# On the "third layer", there's a weighted combination of the two regression models:
ẑ = 0.3ẑ₁ + 0.7ẑ₂;

# And finally we need to invert the initial transformation of the target (which was a log):
ŷ = exp(ẑ);

# You've now defined a full learning network which you can fit and use for prediction:
fit!(ŷ, rows=train)
ypreds = ŷ(rows=test)
rmsl(y[test], ypreds)

# ### Using the "arrow" syntax## If you're using Julia 1.3, you can use the following syntax to do the same thing.
# *First layer*: one hot encoding and log transform:
W = Xs |> OneHotEncoder()
z = ys |> log;

# *Second layer*: KNN Regression and Ridge regression
ẑ₁ = (W, z) |> KNNRegressor(K=5)
ẑ₂ = (W, z) |> RidgeRegressor(lambda=2.5);

# *Third layer*: weighted sum of the two models:
ẑ = 0.3ẑ₁ + 0.7ẑ₂;

# then the inverse transform
ŷ = exp(ẑ);

# You can then fit and evaluate the model as usual:
fit!(ŷ, rows=train)
rmsl(y[test], ŷ(rows=test))

# ### Tuning the model## So far the hyperparameters were explicitly given but it makes more sense to learn them.# For this, we define a model around the learning network which can then be trained and tuned as any model:
mutable struct KNNRidgeBlend <: DeterministicNetwork
    knn_model::KNNRegressor
    ridge_model::RidgeRegressor
    knn_weight::Float64
end

# We must specify how such a model should be fit, which is effectively just the learning network we had defined before except that now the parameters are contained in the struct:
function MLJ.fit(model::KNNRidgeBlend, verbosity::Int, X, y)
    Xs = source(X)
    ys = source(y)
    hot = machine(OneHotEncoder(), Xs)
    W = transform(hot, Xs)
    z = log(ys)
    ridge_model = model.ridge_model
    knn_model = model.knn_model
    ridge = machine(ridge_model, W, z)
    knn = machine(knn_model, W, z)
    # and finally
    ẑ = model.knn_weight * predict(knn, W) + (1.0 - model.knn_weight) * predict(ridge, W)
    ŷ = exp(ẑ)

    mach = machine(Deterministic(), Xs, ys; predict=ŷ)
    fit!(mach, verbosity=verbosity - 1)
    return mach()
end

# **Note**: you really  want to set `verbosity=0` here otherwise in the tuning you will get a lot of verbose output!## You can now instantiate and fit such a model:
krb = KNNRidgeBlend(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(krb, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(y[test], preds)

# But more interestingly, the hyperparameters of the model can be tuned.## Before we get started, it's important to note that the hyperparameters of the model have different levels of *nesting*. This becomes explicit when trying to access elements:
@show krb.knn_weight
@show krb.knn_model.K
@show krb.ridge_model.lambda

# You can also see all the hyperparameters using the `params` function:
params(krb) |> pprint

# The range of values to do your hyperparameter tuning over should follow the nesting structure reflected by `params`:
k_range = range(krb, :(knn_model.K), lower=2, upper=100, scale=:log10)
l_range = range(krb, :(ridge_model.lambda), lower=1e-4, upper=10, scale=:log10)
w_range = range(krb, :(knn_weight), lower=0.1, upper=0.9)

ranges = [k_range, l_range, w_range]

# Now there remains to define how the tuning should be done, let's just specify a very coarse grid tuning with cross validation and instantiate a tuned model:
tuning = Grid(resolution=3)
resampling = CV(nfolds=6)

tm = TunedModel(model=krb, tuning=tuning, resampling=resampling,
                ranges=ranges, measure=rmsl)

# which we can now finally fit...
mtm = machine(tm, X, y)
fit!(mtm, rows=train);

# To retrieve the best model, you can use:
krb_best = fitted_params(mtm).best_model
@show krb_best.knn_model.K
@show krb_best.ridge_model.lambda
@show krb_best.knn_weight

# you can also use `mtm` to make predictions (which will be done using the best model)
preds = predict(mtm, rows=test)
rmsl(y[test], preds)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

