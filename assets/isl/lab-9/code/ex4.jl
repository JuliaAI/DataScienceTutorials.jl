# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

ym1 = y .== -1
ym2 = .!ym1

scatter(X[ym1, 1], X[ym1, 2], markershape=:circle, label="y=-1")
scatter!(X[ym2, 1], X[ym2, 2], markershape=:cross, label="y=1")

plot!(legend=:bottomright, xlabel="X1", ylabel="X2", title="Scatter Plot", size=(800,600))

savefig(joinpath(@OUTPUT, "ISL-lab-9-g1.svg")); # You need to define @OUTPUT