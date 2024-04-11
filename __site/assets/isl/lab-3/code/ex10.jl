# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

plot(X.LStat, y, seriestype=:scatter, markershape=:circle, legend=false, size=(800,600))

Xnew = (LStat = collect(range(extrema(X.LStat)..., length=100)),)
plot!(Xnew.LStat, MLJ.predict(mach_uni, Xnew), linewidth=3, color=:orange)

savefig(joinpath(@OUTPUT, "ISL-lab-3-lm1.svg")); # hide