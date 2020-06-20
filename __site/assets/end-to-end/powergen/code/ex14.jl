# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
hist(data.Wind_gen, color="blue", edgecolor = "white", bins=50,
     density=true, alpha=0.5)
xlabel("Wind power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)

savefig(joinpath(@OUTPUT, "hist_wind.svg")) # hide