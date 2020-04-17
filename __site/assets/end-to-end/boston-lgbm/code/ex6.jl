# This file was generated, do not modify it. # hide
lgb = LGBMRegressor() #initialised a model with default params
lgbm = machine(lgb, features[train, :], targets[train, 1])
learning_range = range(lgb, :learning_rate, lower=1e-3, upper=1, scale=:log)
curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=learning_range, resolution=100,
                        measure=rms)


figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
yscale("log")
xlabel("Learning rate", fontsize=14)
ylabel("RMSE (log scale)", fontsize=14)

plt.savefig(joinpath(@OUTPUT, "lgbm_hp2.svg")) # hide