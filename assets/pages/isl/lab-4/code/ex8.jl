# This file was generated, do not modify it. # hide
fit!(clf)
ŷ = predict(clf, X2)
cross_entropy(ŷ, y) |> mean