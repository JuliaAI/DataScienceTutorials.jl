# This file was generated, do not modify it. # hide
iris2 = coerce(iris, :PetalWidth => OrderedFactor)
first(iris2[[:PetalLength, :PetalWidth]], 1) |> pretty