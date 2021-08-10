using RDatasets
import DataFrames

boston = dataset("MASS", "Boston");

typeof(boston)

using CSV
data = CSV.read(fpath, DataFrames.DataFrame)

typeof(data)

header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read(fpath, DataFrames.DataFrame, header=header)
first(data, 3)

data = CSV.read(fpath, DataFrames.DataFrame, header=false, missingstring="?")
first(data[:, 1:5], 3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

