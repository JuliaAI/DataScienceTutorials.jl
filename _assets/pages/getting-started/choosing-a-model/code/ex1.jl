# This file was generated, do not modify it. # hide
using RDatasets, MLJ
iris = dataset("datasets", "iris")

first(iris, 3) |> pretty