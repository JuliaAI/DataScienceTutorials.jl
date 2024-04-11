# This file was generated, do not modify it. # hide
res = ŷ .- y[test]
plot(
    res,
    line = :stem,
    xlims = (1, length(res)),
    ylims = (-1400, 1000),
    linewidth = 3,
    marker = :circle,
    legend = false,
    size = ((800, 600)),
)
hline!([0], linewidth = 2, color = :red)
xlabel!("Index")
ylabel!("Residual (ŷ - y)")


savefig(joinpath(@OUTPUT, "ISL-lab-6-g5.svg")); # hide