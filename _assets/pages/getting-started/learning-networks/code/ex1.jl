# This file was generated, do not modify it. # hide
using MLJ, DataFrames, Random
@load RidgeRegressor pkg=MultivariateStats

Random.seed!(5) # for reproducibility
x1 = rand(300)
x2 = rand(300)
x3 = rand(300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(300))
X = DataFrame(x1=x1, x2=x2, x3=x3)
first(X, 3) |> pretty