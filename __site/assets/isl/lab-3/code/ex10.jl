# This file was generated, do not modify it. # hide
using PyPlot
ioff() # hide

figure(figsize=(8,6))
plot(X.LStat, y, ls="none", marker="o")
Xnew = (LStat = collect(range(extrema(X.LStat)..., length=100)),)
plot(Xnew.LStat, MLJ.predict(mach_uni, Xnew))

savefig(joinpath(@OUTPUT, "ISL-lab-3-lm1.svg")) # hide