# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

plot(mpg, size=(800,600), linewidth=2, legend=false)

savefig(joinpath(@OUTPUT, "ISL-lab-2-mpg.svg")); # hide