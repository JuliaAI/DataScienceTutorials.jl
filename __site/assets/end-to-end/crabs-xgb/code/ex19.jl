# This file was generated, do not modify it. # hide
PyPlot.close_figs() # hide
ŷ = predict_mode(mtm, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)