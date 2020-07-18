# This file was generated, do not modify it. # hide
figure(figsize=(8,6))

plt.hist(data_nmiss.plant_age, color="blue", edgecolor="white", bins=100,
      density=true, alpha=0.5)
plt.axvline(mean_age, label = "Mean", color = "red")
plt.axvline(median_age, label = "Median")

plt.legend()

plt.xlim(0,)

savefig(joinpath(@OUTPUT, "D0-processing-g2.svg")) # hide