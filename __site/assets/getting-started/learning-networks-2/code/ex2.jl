# This file was generated, do not modify it. # hide
using MLJ
using StableRNGs
import DataFrames: DataFrame
MLJ.color_off() # hide
Ridge = @load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(6616) # for reproducibility
x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))
X = DataFrame(x1=x1, x2=x2, x3=x3)

test, train = partition(eachindex(y), 0.8);