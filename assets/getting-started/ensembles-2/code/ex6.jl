# This file was generated, do not modify it. # hide
rng = StableRNG(5123) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve(m, resampling=Holdout(fraction_train=0.8, rng=rng),
                         range=r, measure=rms);