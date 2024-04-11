# This file was generated, do not modify it. # hide
r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=234),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)