# This file was generated, do not modify it. # hide
y, X = unpack(caravan, ==(:Purchase), col->true)

std = machine(Standardizer(), X)
fit!(std)
Xs = transform(std, X)

var(Xs[:,1]) |> r3