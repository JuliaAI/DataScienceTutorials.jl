# This file was generated, do not modify it. # hide
using MLJ
import DataFrames: DataFrame
import Statistics
MLJ.color_off() # hide

X, y = @load_reduced_ames
X = DataFrame(X)
@show size(X)
first(X, 3)