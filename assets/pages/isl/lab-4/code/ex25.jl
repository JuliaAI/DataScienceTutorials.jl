# This file was generated, do not modify it. # hide
knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3