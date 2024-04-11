# This file was generated, do not modify it. # hide
r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tuned_model = TunedModel(
    xgb,
    tuning=Grid(resolution=8),
    resampling=CV(rng=11),
    ranges=[r1,r2],
    measure=brier_loss,
)
mach = machine(tuned_model, X, y)
fit!(mach, rows=train)