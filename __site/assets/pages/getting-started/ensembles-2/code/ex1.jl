# This file was generated, do not modify it. # hide
using MLJ, PyPlot, PrettyPrinting, Random,
      DataFrames

X, y = @load_boston
sch = schema(X)
p = length(sch.names)
n = sch.nrows
@show (n, p)
describe(y)