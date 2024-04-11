# This file was generated, do not modify it. # hide
using MLJ
import RDatasets: dataset
using PrettyPrinting
MLJ.color_off() # hide
import Distributions as D

LinearRegressor = @load LinearRegressor pkg = MLJLinearModels
RidgeRegressor = @load RidgeRegressor pkg = MLJLinearModels
LassoRegressor = @load LassoRegressor pkg = MLJLinearModels