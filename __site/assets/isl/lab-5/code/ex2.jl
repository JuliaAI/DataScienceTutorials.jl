# This file was generated, do not modify it. # hide
using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select
MLJ.color_off() # hide
auto = dataset("ISLR", "Auto")
y, X = unpack(auto, ==(:MPG))
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=444);