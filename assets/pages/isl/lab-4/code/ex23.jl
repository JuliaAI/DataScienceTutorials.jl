# This file was generated, do not modify it. # hide
knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])