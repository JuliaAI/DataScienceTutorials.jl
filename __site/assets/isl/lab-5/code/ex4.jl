# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

plot(X.Horsepower, y, seriestype=:scatter, legend=false,  size=(800,600))
xlabel!("Horsepower")
ylabel!("MPG")

savefig(joinpath(@OUTPUT, "ISL-lab-5-g1.svg")); # hide