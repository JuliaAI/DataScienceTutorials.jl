# This file was generated, do not modify it. # hide
using MLJ, StableRNGs
import DataFrames
MLJ.color_off() # hide
@load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(551234) # for reproducibility

x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))

X = DataFrames.DataFrame(x1=x1, x2=x2, x3=x3)
first(X, 3) |> pretty