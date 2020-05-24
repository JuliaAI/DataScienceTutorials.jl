# This file was generated, do not modify it. # hide
using MLJ
using  PrettyPrinting
import DataFrames
import Statistics
MLJ.color_off() # hide

X, y = @load_reduced_ames
X = DataFrames.DataFrame(X)
@show size(X)
first(X, 3) |> pretty