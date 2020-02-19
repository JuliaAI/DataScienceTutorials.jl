# This file was generated, do not modify it. # hide
using PyPlot
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/ISL-lab-4-volume.svg") # hide