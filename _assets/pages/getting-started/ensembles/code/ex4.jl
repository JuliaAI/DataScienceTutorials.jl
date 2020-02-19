# This file was generated, do not modify it. # hide
fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
rms(ŷ, y[test])