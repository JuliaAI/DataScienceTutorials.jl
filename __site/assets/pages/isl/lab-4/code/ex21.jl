# This file was generated, do not modify it. # hide
@load LDA pkg=MultivariateStats
using Distances

clf = machine(LDA(dist=CosineDist()), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3