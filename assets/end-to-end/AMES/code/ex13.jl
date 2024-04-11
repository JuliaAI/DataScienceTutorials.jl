# This file was generated, do not modify it. # hide
knn   = machine(KNNRegressor(K=5), W, z)
ridge = machine(RidgeRegressor(lambda=2.5), W, z)

ẑ₁ = predict(knn, W)
ẑ₂ = predict(ridge, W)