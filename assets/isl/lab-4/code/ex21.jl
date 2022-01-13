# This file was generated, do not modify it. # hide
BayesianLDA = @load BayesianLDA pkg=MultivariateStats

classif = machine(BayesianLDA(), X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3