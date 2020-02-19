# This file was generated, do not modify it. # hide
using MLJ, DataFrames, Statistics, PrettyPrinting

Xraw = rand(300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(300))
X = DataFrame(Xraw)

train, test = partition(eachindex(y), 0.7);