# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

plot(curves.parameter_values, curves.measurements,
xticks = [10, 100, 250, 500, 750, 1000],
size=(800,600), linewidth=2, legend=false)
xlabel!("Number of trees")
ylabel!("Root Mean Squared error")

savefig(joinpath(@OUTPUT, "A-ensembles-2-curves.svg")); # hide