# This file was generated, do not modify it. # hide
plt.figure(figsize=(8,6))
plt.hist(df.price[df.isrenovated .== true], color="blue", density=true,
        edgecolor="white", bins=50, label="renovated", alpha=0.5)
plt.hist(df.price[df.isrenovated .== false], color="red", density=true,
        edgecolor="white", bins=50, label="unrenovated", alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.legend(fontsize=12)
plt.savefig(joinpath(@OUTPUT, "hist_price2.svg")) # hide