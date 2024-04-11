# This file was generated, do not modify it. # hide
x1 = W.x1
x2 = W.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

scatter(x1[mask_1], x2[mask_1], color="red", label="Class 1")
scatter!(x1[mask_2], x2[mask_2], color="blue", label="Class 2")
scatter!(x1[mask_3], x2[mask_3], color="yellow", label="Class 3")

xlabel!("PCA dimension 1")
ylabel!("PCA dimension 2")

savefig(joinpath(@OUTPUT, "EX-wine-pca.svg")); # hide