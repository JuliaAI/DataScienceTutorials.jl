# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

steps(x) = x < -3/2 ? -1 : (x < 3/2 ? 0 : 1)
x = Float64[-4, -1, 2, -3, 0, 3, -2, 1, 4]
Xraw = (x = x, )
yraw = steps.(x);
idxsort = sortperm(x)
xsort = x[idxsort]
ysort = yraw[idxsort]
plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(x, yraw, seriestype=:scatter, markershape=:circle, label="data", xlim=(-4.5, 4.5))

savefig(joinpath(@OUTPUT, "s1.svg")); # hide