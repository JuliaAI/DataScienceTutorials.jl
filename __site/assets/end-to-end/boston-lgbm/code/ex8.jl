# This file was generated, do not modify it. # hide
leaf_range = range(lgb, :min_data_in_leaf, lower=1, upper=50)


curve = learning_curve!(lgbm, resampling=CV(nfolds=5),
                        range=leaf_range, resolution=50,
                        measure=rms)

figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Min data in leaf", fontsize=14)
ylabel("RMSE", fontsize=14)

plt.savefig(joinpath(@OUTPUT, "lgbm_hp3.svg")) # hide