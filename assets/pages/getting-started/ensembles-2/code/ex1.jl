# This file was generated, do not modify it. # hide
using MLJ, PyPlot, PrettyPrinting, Random

X, y = @load_boston
@show size(X)
@show y[1:3]
first(X, 3) |> pretty