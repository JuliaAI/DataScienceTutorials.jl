# This file was generated, do not modify it. # hide
fit!(yhat, verbosity=0)

figure(figsize=(8,6))
step(xsort, ysort, label="truth", where="mid")
plot(x, yhat(), ls="none", marker="o", label="yhat")

savefig(joinpath(@OUTPUT, "s4.svg")) # hide