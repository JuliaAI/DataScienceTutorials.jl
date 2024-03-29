# This file was generated, do not modify it. # hide
using PyPlot
ioff() # hide

figure(figsize=(8,6))

PyPlot.bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-10-g1.svg")) # hide