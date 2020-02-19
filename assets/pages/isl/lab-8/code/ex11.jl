# This file was generated, do not modify it. # hide
r_depth = range(dtr_model, :max_depth, lower=2, upper=20)

tm = TunedModel(model=dtr_model, ranges=[r_depth], tuning=Grid(resolution=10),
                resampling=CV(nfolds=5, rng=1254), measure=rms)
mtm = machine(tm, X, y)

fit!(mtm, rows=train)

ypred = predict(mtm, rows=test)
round(rms(ypred, y[test]), sigdigits=3)