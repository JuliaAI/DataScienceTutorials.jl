# This file was generated, do not modify it.

using RDatasets

boston = dataset("MASS", "Boston");

first(boston, 4)

using StatsBase
describe(boston, :min, :max, :mean, :median, :std)

