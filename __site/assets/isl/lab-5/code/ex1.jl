# This file was generated, do not modify it. # hide
using MLJ, RDatasets
MLJ.color_off() # hide
auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG), col->true)
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);