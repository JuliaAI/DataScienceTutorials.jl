# This file was generated, do not modify it. # hide
x = randn(1_000) # 1_000 points iid from a N(0, 1)
μ = mean(x)
σ = std(x)
@show (μ, σ)