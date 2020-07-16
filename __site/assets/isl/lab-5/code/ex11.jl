# This file was generated, do not modify it. # hide
Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(LinMod, :(feature_selector.features), values=cases)

tm = TunedModel(model=LinMod, ranges=r, resampling=CV(nfolds=10), measure=rms)