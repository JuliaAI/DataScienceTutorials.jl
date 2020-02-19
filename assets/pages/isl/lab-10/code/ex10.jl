# This file was generated, do not modify it. # hide
using PyPlot

figure(figsize=(8,6))

bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

savefig("assets/literate/ISL-lab-10-g1.svg") # hide