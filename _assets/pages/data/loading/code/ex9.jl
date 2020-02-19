# This file was generated, do not modify it. # hide
data = CSV.read(fpath, header=false, missingstring="?")
first(data[:, 1:5], 3)