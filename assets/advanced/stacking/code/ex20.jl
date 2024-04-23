# This file was generated, do not modify it. # hide
fit!(y1_oos, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(
    x,
    y1_oos(),
    seriestype=:scatter,
    markershape=:circle,
    label="linear oos",
    xlim=(-4.5, 4.5),
)

savefig(joinpath(@OUTPUT, "s2.svg")); # hide