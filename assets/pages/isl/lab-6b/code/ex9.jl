# This file was generated, do not modify it. # hide
mtm.model.model.reg = LassoRegressor()
mtm.model.ranges = range(model, :(reg.lambda), lower=500, upper=100_000, scale=:log10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.reg.lambda, sigdigits=4)