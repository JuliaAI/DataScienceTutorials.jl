# This file was generated, do not modify it. # hide
mce = cross_entropy(ŷ, y[test]) |> mean
round(mce, digits=4)