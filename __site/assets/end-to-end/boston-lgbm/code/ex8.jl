# This file was generated, do not modify it. # hide
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