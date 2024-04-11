# This file was generated, do not modify it. # hide
r = range(
    model,
    :(linear_regressor.lambda),
    lower = 1e-2,
    upper = 100,
    scale = :log10,
)
tm = TunedModel(
    model,
    ranges = r,
    tuning = Grid(resolution = 50),
    resampling = CV(nfolds = 3, rng = 4141),
    measure = rms,
)
mtm = machine(tm, Xc, y)
fit!(mtm, rows = train)

best_mdl = fitted_params(mtm).best_model
round(best_mdl.linear_regressor.lambda, sigdigits = 4)