# This file was generated, do not modify it. # hide
ridge_model = Ridge(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)