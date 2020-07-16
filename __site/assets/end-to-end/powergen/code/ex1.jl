# This file was generated, do not modify it. # hide
using MLJ
using UrlDownload
using PyPlot
ioff() # hide
import DataFrames: DataFrame, describe, names, select!
using Statistics

@load LinearRegressor pkg=MLJLinearModels