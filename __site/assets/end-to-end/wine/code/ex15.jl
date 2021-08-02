# This file was generated, do not modify it. # hide
opts = (resampling=Holdout(fraction_train=0.9), measure=cross_entropy)
res = evaluate!(knn; opts...)
round(res.measurement[1], sigdigits=3)