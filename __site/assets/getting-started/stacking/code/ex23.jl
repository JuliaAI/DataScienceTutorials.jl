# This file was generated, do not modify it. # hide
fit!(y1_oos, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, y1_oos(), ls="none", marker="o", label="linear oos")
legend()

savefig(joinpath(@OUTPUT, "s2.svg")) # hide