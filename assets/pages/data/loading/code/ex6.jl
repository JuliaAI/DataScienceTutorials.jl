# This file was generated, do not modify it. # hide
data = CSV.read(joinpath(@__DIR__, "data", "hcc.txt"),
                header=false, missingstring="?")
first(data[:, 1:5], 3)