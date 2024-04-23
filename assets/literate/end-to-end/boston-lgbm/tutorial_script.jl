# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/boston-lgbm/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import DataFrames
import Statistics
import StableRNGs.StableRNG

MLJ.color_off() # hide
LGBMRegressor = @load LGBMRegressor pkg=LightGBM

features, targets = @load_boston
features = DataFrames.DataFrame(features);
@show size(features)
@show targets[1:3]
first(features, 3)

schema(features)

DataFrames.describe(features)

train, test = partition(eachindex(targets), 0.70, rng=StableRNG(52))

lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])
curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :num_iterations, lower=2, upper=500),
    resolution=60,
    measure=rms,
)

using Plots
dims = (600, 370)
plt = plot(curve.parameter_values, curve.measurements, size=dims)
xlabel!("Number of rounds", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp1.svg")); # hide

lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])

curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :learning_rate, lower=1e-3, upper=1, scale=:log),
    resolution=60,
    measure=rms,
)

plot(
    curve.parameter_values,
    curve.measurements,
    size=dims,
    xscale =:log10,
)
xlabel!("Learning rate (log scale)", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp2.svg")); # hide

lgb = LGBMRegressor() #initialised a model with default params
mach = machine(lgb, features[train, :], targets[train, 1])

curve = learning_curve(
    mach,
    resampling=CV(nfolds=5),
    range=range(lgb, :min_data_in_leaf, lower=1, upper=50),
    measure=rms,
)

plot(curve.parameter_values, curve.measurements, size=dims)
xlabel!("Min data in leaf", fontsize=14)
ylabel!("RMSE", fontsize=14)

savefig(joinpath(@OUTPUT, "lgbm_hp3.svg")); # hide

r1 = range(lgb, :num_iterations, lower=50, upper=100)
r2 = range(lgb, :min_data_in_leaf, lower=2, upper=10)
r3 = range(lgb, :learning_rate, lower=1e-1, upper=1e0)
tuned_model = TunedModel(
    lgb,
    tuning=RandomSearch(),
    resampling=CV(rng=StableRNG(123)),
    ranges=[r1,r2,r3],
    measure=rms,
    n=100,
)
mach = machine(tuned_model, features, targets)
fit!(mach, rows=train);

best_model = fitted_params(mach).best_model
@show best_model.learning_rate
@show best_model.min_data_in_leaf
@show best_model.num_iterations

predictions = MLJ.predict(mach, rows=test)
rms_score = round(rms(predictions, targets[test, 1]), sigdigits=4)

@show rms_score
