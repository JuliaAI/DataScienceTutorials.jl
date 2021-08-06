# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
hist(res, color="blue", edgecolor="white", bins=50,
     density=true, alpha=0.5)

savefig(joinpath(@OUTPUT, "hist_residuals.svg")) # hide