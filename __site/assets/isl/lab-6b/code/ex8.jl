# This file was generated, do not modify it. # hide
histogram(y, bins = 50, normalize = true, label = false, size = (800, 600))
xlabel!("Salary")
ylabel!("Density")

edfit = D.fit_mle(D.Exponential, y)
xx = range(minimum(y), 2500, length = 100)
yy = pdf.(edfit, xx)
plot!(
    xx,
    yy,
    label = "Exponential distribution fit",
    linecolor = :orange,
    linewidth = 4,
)

savefig(joinpath(@OUTPUT, "ISL-lab-6-g2.svg")); # hide