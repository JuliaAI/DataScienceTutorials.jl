# This file was generated, do not modify it. # hide
r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve(xgbm, range=r, resolution=50,
                        measure=L1HingeLoss())