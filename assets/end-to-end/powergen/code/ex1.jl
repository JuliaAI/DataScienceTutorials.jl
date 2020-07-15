# This file was generated, do not modify it. # hide
using MLJ
using UrlDownload
using PyPlot
import DataFrames: DataFrame, describe, names, select!
using Statistics

@load LinearRegressor pkg=MLJLinearModels