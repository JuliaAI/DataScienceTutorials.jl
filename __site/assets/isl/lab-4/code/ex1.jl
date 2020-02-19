# This file was generated, do not modify it. # hide
using MLJ, RDatasets, DataFrames, Statistics
import StatsBase: countmap
MLJ.color_off() # hide
using PrettyPrinting

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)