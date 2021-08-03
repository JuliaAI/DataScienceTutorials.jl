# This file was generated, do not modify it. # hide
train, test = partition(collect(eachindex(y)), 0.7, shuffle=true, rng=StableRNG(612));