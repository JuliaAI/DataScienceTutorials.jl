# This file was generated, do not modify it. # hide
train, test = partition(eachindex(targets), 0.70, shuffle=true,
                        rng=StableRNG(52))