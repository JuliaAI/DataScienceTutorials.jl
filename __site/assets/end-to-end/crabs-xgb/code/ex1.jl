# This file was generated, do not modify it. # hide
using MLJ
using StatsBase
using Random
using PyPlot
ioff() # hide
using CategoricalArrays
using PrettyPrinting
import DataFrames
using LossFunctions

MLJ.color_off() # hide
X, y = @load_crabs
X = DataFrames.DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3) |> pretty