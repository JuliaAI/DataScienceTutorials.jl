# This file was generated, do not modify it. # hide
using MLJ, RDatasets, PrettyPrinting, ScientificTypes

@load DecisionTreeClassifier pkg=DecisionTree

carseats = dataset("ISLR", "Carseats")

first(carseats, 3) |> pretty