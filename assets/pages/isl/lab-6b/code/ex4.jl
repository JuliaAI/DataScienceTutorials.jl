# This file was generated, do not modify it. # hide
using PyPlot

figure(figsize=(8,6))
plot(y, ls="none", marker="o")

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Index", fontsize=14), ylabel("Salary", fontsize=14)

savefig("assets/literate/ISL-lab-6-g1.svg") # hide