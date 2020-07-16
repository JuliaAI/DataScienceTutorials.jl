# This file was generated, do not modify it. # hide
surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=ŷ)

fit!(ŷ)
ŷ(X[test, :])