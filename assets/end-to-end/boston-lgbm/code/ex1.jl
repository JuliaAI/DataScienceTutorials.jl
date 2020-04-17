# This file was generated, do not modify it. # hide
using MLJ, PrettyPrinting, DataFrames, Statistics
using PyPlot, Random

MLJ.color_off() # hide
Random.seed!(1212)
@load LGBMRegressor