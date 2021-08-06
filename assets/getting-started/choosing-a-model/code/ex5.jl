# This file was generated, do not modify it. # hide
y, X = unpack(iris, ==(:Species), !=(:PetalLength))
first(X, 1) |> pretty