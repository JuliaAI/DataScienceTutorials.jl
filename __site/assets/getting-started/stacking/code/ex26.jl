# This file was generated, do not modify it. # hide
fit!(yhat, verbosity=0)

plot(xsort, ysort, linetype=:stepmid, label="truth")
plot!(x, yhat(), seriestype=:scatter, markershape=:circle, label="yhat", xlim=(-4.5, 4.5))


savefig(joinpath(@OUTPUT, "s4.svg")); # hide