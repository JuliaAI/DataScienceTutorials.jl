# This file was generated, do not modify it. # hide
figure(figsize=(8,6))
steps(x) = x < -3/2 ? -1 : (x < 3/2 ? 0 : 1)
x = Float64[-4, -1, 2, -3, 0, 3, -2, 1, 4]
Xraw = (x = x, )
yraw = steps.(x);
idxsort = sortperm(x)
xsort = x[idxsort]
ysort = yraw[idxsort]
step(xsort, ysort, label="truth", where="mid")
plot(x, yraw, ls="none", marker="o", label="data")
xlim(-4.5, 4.5)
legend()

savefig(joinpath(@OUTPUT, "s1.svg")) # hide