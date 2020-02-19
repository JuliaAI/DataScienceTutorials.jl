# This file was generated, do not modify it. # hide
cm = machine(CompositeModel(), X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8),
                measure=rms)
round(res.measurement[1], sigdigits=3)