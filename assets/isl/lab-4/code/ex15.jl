# This file was generated, do not modify it. # hide
@show false_positive(cm)
@show accuracy(ŷ, y)  |> r3
@show accuracy(cm)    |> r3  # same thing
@show positive_predictive_value(ŷ, y) |> r3   # a.k.a. precision
@show recall(ŷ, y)    |> r3
@show f1score(ŷ, y)   |> r3