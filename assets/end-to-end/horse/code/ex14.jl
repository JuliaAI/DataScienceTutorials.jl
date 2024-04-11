# This file was generated, do not modify it. # hide
@load FillImputer
filler = machine(FillImputer(), data[all, :]) |> fit!
data = MLJ.transform(filler, data)

y, X = unpack(data, ==(:outcome)); # a vector and a table