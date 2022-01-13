# This file was generated, do not modify it. # hide
ŷ = predict(tuned_ensemble, rows=test)
@show rms(ŷ, y[test])


PyPlot.close_figs() # hide