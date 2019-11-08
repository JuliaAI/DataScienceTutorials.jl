# This file was generated, do not modify it. # hide
using MLJ, StatsBase, Random, PyPlot, CategoricalArrays, PrettyPrinting, DataFrames
X, y = @load_crabs
X = DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3) |> pretty