# This file was generated, do not modify it. # hide
r  = range(model, :(reg.lambda), lower=1e-2, upper=1e9, scale=:log10)
tm = TunedModel(model=model, ranges=r, tuning=Grid(resolution=50),
                measure=rms)
mtm = machine(tm, Xc, y)
fit!(mtm, rows=train)

best_mdl = fitted_params(mtm).best_model
@show round(best_mdl.reg.lambda, sigdigits=4)