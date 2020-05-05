# This file was generated, do not modify it.

using MLJ, PrettyPrinting, DataFrames, Statistics
using PyPlot, Random

MLJ.color_off() # hide
Random.seed!(1212)
@load LGBMRegressor

features, targets = @load_boston
features = DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> pretty

describe(features)

train, test = partition(eachindex(targets), 0.70, shuffle=true, rng=52)

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

plt.savefig(joinpath(@OUTPUT, "lgbm_hp1.svg")) # hide

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

plt.savefig(joinpath(@OUTPUT, "lgbm_hp2.svg")) # hide

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

plt.savefig(joinpath(@OUTPUT, "lgbm_hp3.svg")) # hide

r1 = range(lgb, :num_iterations, lower=50, upper=100)
r2 = range(lgb, :min_data_in_leaf, lower=2, upper=10)
r3 = range(lgb, :learning_rate, lower=1e-1, upper=1e0)
tm = TunedModel(model=lgb, tuning=Grid(resolution=5),
                resampling=CV(rng=123), ranges=[r1,r2,r3],
                measure=rms)
mtm = machine(tm, features, targets)
fit!(mtm, rows=train)

best_model = fitted_params(mtm).best_model
@show best_model.learning_rate
@show best_model.min_data_in_leaf
@show best_model.num_iterations

predictions = predict(mtm, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score

PyPlot.close_figs() # hide

