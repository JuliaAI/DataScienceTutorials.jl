# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

Plots.bar(1:length(cs), cs, legend=false, size=((800,600)), ylim=(0, 1.1))
xlabel!("Number of PCA features")
ylabel!("Ratio of explained variance")
plot!(1:length(cs), cs, color="red", marker="o", linewidth=3)

savefig(joinpath(@OUTPUT, "ISL-lab-10-g1.svg")); # hide