# This file was generated, do not modify it. # hide
using HTTP, CSV, MLJ, StatsBase, PyPlot
req = HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data")
data = CSV.read(req.body,
                header=["Class", "Alcool", "Malic acid",
                        "Ash", "Alcalinity of ash", "Magnesium",
                        "Total phenols", "Flavanoids",
                        "Nonflavanoid phenols", "Proanthcyanins",
                        "Color intensity", "Hue",
                        "OD280/OD315 of diluted wines", "Proline"])
# the target is the Class column, everything else is a feature
y, X = unpack(data, ==(:Class), colname->true);