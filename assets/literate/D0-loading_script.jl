# This file was generated, do not modify it.

using RDatasets

boston = dataset("MASS", "Boston");

typeof(boston)

using CSV
data = CSV.read("scripts/data/foo.csv")

typeof(data)

header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read("scripts/data/qsar.csv", header=header)
first(data, 3)

data = CSV.read("scripts/data/hcc.txt", header=false, missingstring="?")
first(data[:, 1:5], 3)

