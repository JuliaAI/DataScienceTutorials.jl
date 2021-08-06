# This file was generated, do not modify it. # hide
train, test = partition(collect(eachindex(targets)), 0.70, shuffle=true,
                        rng=StableRNG(52))