# This file was generated, do not modify it. # hide
ŷ = predict_mode(mtm, rows=test)
round(misclassification_rate(ŷ, y[test]), sigdigits=3)