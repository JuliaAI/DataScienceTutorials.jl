# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

plot(X.Volume, size=(800,600), linewidth=2, legend=false)
xlabel!("Tick number")
ylabel!("Volume")

savefig(joinpath(@OUTPUT, "ISL-lab-4-volume.svg")); # hide