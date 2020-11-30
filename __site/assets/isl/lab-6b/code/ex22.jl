# This file was generated, do not modify it. # hide
@load ElasticNetRegressor pkg=MLJLinearModels

mtm.model.model.linear_regressor = ElasticNetRegressor()
mtm.model.range = [range(model, :(linear_regressor.lambda), lower=0.1, upper=100, scale=:log10),
                    range(model, :(linear_regressor.gamma),  lower=500, upper=10_000, scale=:log10)]
mtm.model.tuning = Grid(resolution=10)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.linear_regressor.lambda, sigdigits=4)
@show round(best_mdl.linear_regressor.gamma, sigdigits=4)