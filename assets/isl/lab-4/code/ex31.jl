# This file was generated, do not modify it. # hide
y, X = unpack(caravan, ==(:Purchase))

mstd = machine(Standardizer(), X)
fit!(mstd)
Xs = MLJ.transform(mstd, X)

var(Xs[:,1]) |> r3