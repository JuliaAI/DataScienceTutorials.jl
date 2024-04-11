# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

plot(
    y,
    seriestype = :scatter,
    markershape = :circle,
    legend = false,
    size = (800, 600),
)

xlabel!("Index")
ylabel!("Salary")