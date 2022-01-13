# This file was generated, do not modify it. # hide
using MLJ
import DataFrames: DataFrame
using PrettyPrinting
using StableRNGs
MLJ.color_off() # hide

rng = StableRNG(512)
Xraw = rand(rng, 300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(rng, 300))
X = DataFrame(Xraw, :auto)

train, test = partition(eachindex(y), 0.7);