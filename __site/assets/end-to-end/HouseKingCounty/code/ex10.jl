# This file was generated, do not modify it. # hide
plt.figure(figsize=(8,6))
plt.hist(df.price, color = "blue", edgecolor = "white", bins=50,
         density=true, alpha=0.5)
plt.xlabel("Price", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.savefig(joinpath(@OUTPUT, "hist_price.svg")) # hide