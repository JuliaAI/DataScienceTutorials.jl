# This file was generated, do not modify it. # hide
using MLJ, StatsBase, Random, PyPlot
X, y = @load_crabs
@show size(X)
@show y[1:3]
first(X, 3) |> pretty