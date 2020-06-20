# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
hist(data.Solar_gen, color="blue", edgecolor="white", bins=100,
     density=true, alpha=0.5)
xlabel("Solar power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)
xticks(fontsize=12)
yticks([0, 1e-3, 2e-3], fontsize=12)
savefig(joinpath(@OUTPUT, "hist_solar.svg")) # hide