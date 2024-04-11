# This file was generated, do not modify it. # hide
ŷ = predict(tuned_ensemble, rows=test)
@show l2(ŷ, y[test])