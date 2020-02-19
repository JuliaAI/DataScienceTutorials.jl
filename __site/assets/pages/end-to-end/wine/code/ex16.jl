# This file was generated, do not modify it. # hide
x1 = W.x1
x2 = W.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

figure(figsize=(8, 6))
plot(x1[mask_1], x2[mask_1], linestyle="none", marker="o", color="red")
plot(x1[mask_2], x2[mask_2], linestyle="none", marker="o", color="blue")
plot(x1[mask_3], x2[mask_3], linestyle="none", marker="o", color="magenta")

xlabel("PCA dimension 1", fontsize=14)
ylabel("PCA dimension 2", fontsize=14)
legend(["Class 1", "Class 2", "Class 3"], fontsize=12)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/EX-wine-pca.svg") # hide