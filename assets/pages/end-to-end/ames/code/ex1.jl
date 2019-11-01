# This file was generated, do not modify it. # hide
using MLJ, PrettyPrinting, DataFrames, Statistics

X, y = @load_reduced_ames
@show size(X)
first(X, 3) |> pretty