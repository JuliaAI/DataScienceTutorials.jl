# This file was generated, do not modify it. # hide
histogram(
    res,
    bins = 30,
    normalize = true,
    color = :green,
    label = false,
    size = (800, 600),
    xlims = (-1100, 1100),
)

xx    = range(-1100, 1100, length = 100)
ndfit = D.fit_mle(D.Normal, res)
lfit  = D.fit_mle(D.Laplace, res)

plot!(xx, pdf.(ndfit, xx), linecolor = :orange, label = "Normal fit", linewidth = 3)
plot!(xx, pdf.(lfit, xx), linecolor = :magenta, label = "Laplace fit", linewidth = 3)
xlabel!("Residual (ŷ - y)")
ylabel!("Density")

savefig(joinpath(@OUTPUT, "ISL-lab-6-g4.svg")); # hide