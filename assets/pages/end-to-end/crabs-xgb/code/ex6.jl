# This file was generated, do not modify it. # hide
r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve!(xgbm, resampling=CV(nfolds=3),
                        range=r, resolution=50,
                        measure=HingeLoss())