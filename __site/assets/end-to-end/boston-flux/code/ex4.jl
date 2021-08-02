# This file was generated, do not modify it. # hide
train, test = MLJ.partition(MLJ.eachindex(targets), 0.70, rng=52)