# This file was generated, do not modify it. # hide
using MLJ
import RDatasets: dataset
using PrettyPrinting
import DataFrames: DataFrame, select, Not
MLJ.color_off() # hide
@load DecisionTreeClassifier pkg=DecisionTree

carseats = dataset("ISLR", "Carseats")

first(carseats, 3) |> pretty