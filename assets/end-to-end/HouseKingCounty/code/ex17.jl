# This file was generated, do not modify it. # hide
cv3 = CV(; nfolds=3)
res = evaluate(rf_mdl, X, y, resampling=CV(shuffle=true),
               measure=rms, verbosity=0)