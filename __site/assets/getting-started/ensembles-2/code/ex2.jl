# This file was generated, do not modify it. # hide
using MLJ
using PrettyPrinting
using StableRNGs
import DataFrames: DataFrame, describe
MLJ.color_off() # hide

X, y = @load_boston
sch = schema(X)
p = length(sch.names)
describe(y)  # From DataFrames