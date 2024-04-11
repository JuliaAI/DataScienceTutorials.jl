# This file was generated, do not modify it. # hide
y2_oos = vcat(y21, y22, y23);
fit!(y2_oos, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(
    x,
    y2_oos(),
    seriestype=:scatter,
    markershape=:circle,
    label="knn oos",
    xlim=(-4.5, 4.5),
)


savefig(joinpath(@OUTPUT, "s3.svg")); # hide