# This file was generated, do not modify it. # hide
@load ElasticNetRegressor pkg=MLJLinearModels

mtm.model.model.reg = ElasticNetRegressor()
mtm.model.ranges = [range(model, :(reg.lambda), lower=0.1, upper=100, scale=:log10),
                    range(model, :(reg.gamma),  lower=500, upper=10_000, scale=:log10)]
mtm.model.tuning = Grid(resolution=10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)
@show round(best_mdl.reg.gamma, sigdigits=4)