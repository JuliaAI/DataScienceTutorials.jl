# This file was generated, do not modify it. # hide
using RDatasets
using MLJ
MLJ.color_off() # hide
iris = dataset("datasets", "iris")

first(iris, 3) |> pretty