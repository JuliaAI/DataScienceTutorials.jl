# This file was generated, do not modify it. # hide
train, test = MLJ.partition(collect(eachindex(targets)), 0.70, rng=52)