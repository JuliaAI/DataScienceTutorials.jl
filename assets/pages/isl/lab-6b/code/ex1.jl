# This file was generated, do not modify it. # hide
using MLJ, RDatasets, ScientificTypes, PrettyPrinting

@load RidgeRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

hitters = dataset("ISLR", "Hitters")
@show size(hitters)
names(hitters) |> pprint