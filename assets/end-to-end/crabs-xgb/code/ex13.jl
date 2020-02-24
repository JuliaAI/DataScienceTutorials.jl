# This file was generated, do not modify it. # hide
xgbm = machine(xgb, X, y)
r = range(xgb, :gamma, lower=0, upper=10)
curve = learning_curve!(xgbm, range=r, resolution=30,
                        measure=cross_entropy);