# This file was generated, do not modify it. # hide
y, X = unpack(iris, ==(:Species), colname -> true)
first(X, 1) |> pretty