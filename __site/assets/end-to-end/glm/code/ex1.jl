# This file was generated, do not modify it. # hide
using MLJ, CategoricalArrays, PrettyPrinting
import DataFrames: DataFrame, nrow
using UrlDownload
@load LinearRegressor pkg = GLM
@load LinearBinaryClassifier pkg=GLM