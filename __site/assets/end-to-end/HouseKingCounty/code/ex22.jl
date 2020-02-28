# This file was generated, do not modify it. # hide
tm = TunedModel(model=xgb, tuning=Grid(resolution=7),
                resampling=CV(rng=11), ranges=[r1,r2,r3,r4,r5,r6,r7],
                measure=rms)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

rms(y[test], predict(mtm, rows=test))