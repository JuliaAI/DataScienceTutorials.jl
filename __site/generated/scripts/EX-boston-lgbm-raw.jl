# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ
using PrettyPrinting
import DataFrames
import Statistics
using PyPlot
using StableRNGs


@load LGBMRegressor

features, targets = @load_boston
features = DataFrames.DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> pretty

DataFrames.describe(features)

train, test = partition(eachindex(targets), 0.70, shuffle=true,
                        rng=StableRNG(52))

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



lgb = LGBMRegressor() #initialised a model with default params
lgbm = machine(lgb, features[train, :], targets[train, 1])

leaf_range = range(lgb, :min_data_in_leaf, lower=1, upper=50)


curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=leaf_range, resolution=50,
                        measure=rms)

figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Min data in leaf", fontsize=14)
ylabel("RMSE", fontsize=14)



r1 = range(lgb, :num_iterations, lower=50, upper=100)
r2 = range(lgb, :min_data_in_leaf, lower=2, upper=10)
r3 = range(lgb, :learning_rate, lower=1e-1, upper=1e0)
tm = TunedModel(model=lgb, tuning=Grid(resolution=5),
                resampling=CV(rng=StableRNG(123)), ranges=[r1,r2,r3],
                measure=rms)
mtm = machine(tm, features, targets)
fit!(mtm, rows=train);

best_model = fitted_params(mtm).best_model
@show best_model.learning_rate
@show best_model.min_data_in_leaf
@show best_model.num_iterations

predictions = predict(mtm, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

