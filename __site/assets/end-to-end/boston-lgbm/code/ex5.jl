# This file was generated, do not modify it. # hide
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