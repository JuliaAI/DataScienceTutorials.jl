# This file was generated, do not modify it. # hide
data = CSV.read(fpath, DataFrames.DataFrame, header=false, missingstring="?")
first(data[:, 1:5], 3)