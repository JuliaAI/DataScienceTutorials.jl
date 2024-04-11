# This file was generated, do not modify it. # hide
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