# This file was generated, do not modify it. # hide
using MLJ
using UrlDownload
import DataFrames: DataFrame, describe, names, select!
using Statistics

LinearRegressor = @load LinearRegressor pkg = MLJLinearModels