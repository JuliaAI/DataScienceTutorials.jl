# This file was generated, do not modify it. # hide
mtm.model.model.linear_regressor = LassoRegressor()
mtm.model.range = range(
    model,
    :(linear_regressor.lambda),
    lower = 5,
    upper = 1000,
    scale = :log10,
)
fit!(mtm, rows = train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits = 4)