# This file was generated, do not modify it. # hide
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