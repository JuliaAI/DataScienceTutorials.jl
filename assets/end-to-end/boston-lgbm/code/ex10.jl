# This file was generated, do not modify it. # hide
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