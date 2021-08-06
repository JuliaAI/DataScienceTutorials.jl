# This file was generated, do not modify it. # hide
using MLJ, CategoricalArrays, PrettyPrinting
import DataFrames: DataFrame, nrow
using UrlDownload

LinearRegressor = @load LinearRegressor pkg=GLM
LinearBinaryClassifier = @load LinearBinaryClassifier pkg=GLM