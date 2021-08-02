# This file was generated, do not modify it. # hide
using PyPlot
ioff() # hide
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "ISL-lab-4-volume.svg")) # hide