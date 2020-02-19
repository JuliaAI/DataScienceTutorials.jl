# This file was generated, do not modify it. # hide
Xhp = DataFrame([hp.^i for i in 1:10])

cases = [[Symbol("x$j") for j in 1:i] for i in 1:10]
r = range(lrm, :(fs.features), values=cases)

tm = TunedModel(model=lrm, ranges=r, resampling=CV(nfolds=10), measure=rms)