# This file was generated, do not modify it. # hide
using MLJ, RDatasets, Random
MLJ.color_off() # hide

data = dataset("datasets", "USArrests")
names(data)