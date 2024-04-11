# This file was generated, do not modify it. # hide
fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
l2(ŷ, y[test]) # sum of squares loss