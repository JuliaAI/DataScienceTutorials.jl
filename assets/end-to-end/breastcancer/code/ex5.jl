# This file was generated, do not modify it. # hide
figure(figsize=(8, 6))
hist(data.Class)
xlabel("Classes")
ylabel("Number of samples")
plt.savefig(joinpath(@OUTPUT, "Target_class.svg")); # hide