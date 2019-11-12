# This file was generated, do not modify it. # hide
tm.resampling = CV(nfolds=5)
mtm = machine(tm, Xc2, y)
fit!(mtm, rows=train)

ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)