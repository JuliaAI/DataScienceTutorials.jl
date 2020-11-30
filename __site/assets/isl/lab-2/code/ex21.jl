# This file was generated, do not modify it. # hide
using PyPlot
ioff() # hide

figure(figsize=(8,6))
plot(mpg)

savefig(joinpath(@OUTPUT, "ISL-lab-2-mpg.svg")) # hide