# This file was generated, do not modify it. # hide
@load BayesianLDA pkg=MultivariateStats

clf = machine(BayesianLDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])