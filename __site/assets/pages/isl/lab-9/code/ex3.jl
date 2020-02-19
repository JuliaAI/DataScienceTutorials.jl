# This file was generated, do not modify it. # hide
using PyPlot
figure(figsize=(8,6))

ym1 = y .== -1
ym2 = .!ym1
plot(X[ym1, 1], X[ym1, 2], ls="none", marker="o")
plot(X[ym2, 1], X[ym2, 2], ls="none", marker="x")

savefig("assets/literate/ISL-lab-9-g1.svg") # hide