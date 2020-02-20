# This file was generated, do not modify it. # hide
y2_oos = vcat(y21, y22, y23);
fit!(y2_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y2_oos(), ls="none", marker="o", label="knn oos")

savefig(joinpath(@OUTPUT, "s3.svg")) # hide