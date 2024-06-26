# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/isl/lab-2/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

x = [1, 3, 2, 5]
@show x
@show length(x)

y = [4, 5, 6, 1]
z = x .+ y # elementwise operation

X = [1  2; 3 4]

X = reshape([1, 2, 3, 4], 2, 2)

X = permutedims(reshape([1, 2, 3, 4], 2, 2))

X = reshape([1,2,3,4], 2, 2) |> permutedims

x = 4
@show x^2
@show sqrt(x)

sqrt.([4, 9, 16])

using Statistics, StatsBase

x = randn(1_000) # 1_000 points iid from a N(0, 1)
μ = mean(x)
σ = std(x)
@show (μ, σ)

X = [1 2; 3 4; 5 6]
@show X[1, 2]
@show X[:, 1]
@show X[1, :]
@show X[[1, 2], [1, 2]]

size(X)

using CSV

using RDatasets

using DataFrames

auto = dataset("ISLR", "Auto")
first(auto, 3)

describe(auto, :mean, :median, :std)

names(auto)

mpg = auto.MPG
mpg = auto[:, 1]
mpg = auto[:, :MPG]
mpg |> mean

@show size(auto)
@show nrow(auto)
@show ncol(auto)

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.3) #hide

plot(mpg, size=(800,600), linewidth=2, legend=false)

savefig(joinpath(@OUTPUT, "ISL-lab-2-mpg.svg")); # hide
