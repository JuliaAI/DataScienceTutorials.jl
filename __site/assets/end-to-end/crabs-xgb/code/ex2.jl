# This file was generated, do not modify it. # hide
using MLJ
using StatsBase
using Random
using Plots
import DataFrames
import StableRNGs.StableRNG

Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.1) # hide

X, y = @load_crabs # a table and a vector
X = DataFrames.DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3)