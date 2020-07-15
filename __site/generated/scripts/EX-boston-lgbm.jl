# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# **Main author**: Yaqub Alwan (IQVIA).## ## Getting started
using MLJ
using PrettyPrinting
import DataFrames
import Statistics
using PyPlot
using StableRNGs


@load LGBMRegressor

# Let us try LightGBM out by doing a regression task on the Boston house prices dataset.# This is a commonly used dataset so there is a loader built into MLJ.
# Here, the objective is to show how LightGBM can do better than a Linear Regressor# with minimal effort.## We start out by taking a quick peek at the data itself and its statistical properties.
features, targets = @load_boston
features = DataFrames.DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> pretty

# We can also describe the dataframe
DataFrames.describe(features)

# Do the usual train/test partitioning. This is important so we can estimate generalisation.
train, test = partition(eachindex(targets), 0.70, shuffle=true,
                        rng=StableRNG(52))

# Let us investigation some of the commonly tweaked LightGBM parameters. We start with looking at a learning curve for number of boostings.
lgb = LGBMRegressor() #initialised a model with default params
lgbm = machine(lgb, features[train, :], targets[train, 1])
boostrange = range(lgb, :num_iterations, lower=2, upper=500)
curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=boostrange, resolution=100,
                        measure=rms)


figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("RMSE", fontsize=14)



# \fig{lgbm_hp1.svg}
# It looks like that we don't need to go much past 100 boosts
# Since LightGBM is a gradient based learning method, we also have a learning rate parameter which controls the size of gradient updates.# Let us look at a learning curve for this parameter too
lgb = LGBMRegressor() #initialised a model with default params
lgbm = machine(lgb, features[train, :], targets[train, 1])
learning_range = range(lgb, :learning_rate, lower=1e-3, upper=1, scale=:log)
curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=learning_range, resolution=100,
                        measure=rms)


figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xscale("log")
xlabel("Learning rate (log scale)", fontsize=14)
ylabel("RMSE", fontsize=14)



# \fig{lgbm_hp2.svg}
# It seems like near 0.5 is a reasonable place. Bearing in mind that for lower# values of learning rate we possibly require more boosting in order to converge, so the default# value of 100 might not be sufficient for convergence. We leave this as an exercise to the reader.# We can still try to tune this parameter, however.
# Finally let us check number of datapoints required to produce a leaf in an individual tree. This parameter# controls the complexity of individual learner trees, and too low a value might lead to overfitting.
lgb = LGBMRegressor() #initialised a model with default params
lgbm = machine(lgb, features[train, :], targets[train, 1])

# dataset is small enough and the lower and upper sets the tree to have certain number of leaves
leaf_range = range(lgb, :min_data_in_leaf, lower=1, upper=50)


curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=leaf_range, resolution=50,
                        measure=rms)

figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Min data in leaf", fontsize=14)
ylabel("RMSE", fontsize=14)



# \fig{lgbm_hp3.svg}
# It does not seem like there is a huge risk for overfitting, and lower is better for this parameter.
# Using the learning curves above we can select some small-ish ranges to jointly search for the best# combinations of these parameters via cross validation.
r1 = range(lgb, :num_iterations, lower=50, upper=100)
r2 = range(lgb, :min_data_in_leaf, lower=2, upper=10)
r3 = range(lgb, :learning_rate, lower=1e-1, upper=1e0)
tm = TunedModel(model=lgb, tuning=Grid(resolution=5),
                resampling=CV(rng=StableRNG(123)), ranges=[r1,r2,r3],
                measure=rms)
mtm = machine(tm, features, targets)
fit!(mtm, rows=train);

# Lets see what the cross validation best model parameters turned out to be?
best_model = fitted_params(mtm).best_model
@show best_model.learning_rate
@show best_model.min_data_in_leaf
@show best_model.num_iterations

# Great, and now let's predict using the held out data.
predictions = predict(mtm, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

