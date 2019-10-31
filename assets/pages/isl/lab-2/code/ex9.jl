# This file was generated, do not modify it. # hide
using Statistics, StatsBase

x = randn(1_000) # 500 points iid from a N(0, 1)
μ = mean(x)
σ = std(x)
@show (μ, σ)