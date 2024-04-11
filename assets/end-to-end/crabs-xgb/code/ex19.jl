# This file was generated, do not modify it. # hide
ŷ = predict_mode(mach, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)