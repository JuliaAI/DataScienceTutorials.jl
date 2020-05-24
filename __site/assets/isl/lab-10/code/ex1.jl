# This file was generated, do not modify it. # hide
using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select, Not, describe
using Random
MLJ.color_off() # hide

data = dataset("datasets", "USArrests")
names(data)