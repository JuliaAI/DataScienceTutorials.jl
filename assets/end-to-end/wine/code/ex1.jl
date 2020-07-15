# This file was generated, do not modify it. # hide
using HTTP
using MLJ
using PyPlot
ioff() # hide
import DataFrames: DataFrame, describe
using UrlDownload
MLJ.color_off() # hide

url = "http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
header = ["Class", "Alcool", "Malic acid", "Ash", "Alcalinity of ash",
          "Magnesium", "Total phenols", "Flavanoids",
          "Nonflavanoid phenols", "Proanthcyanins", "Color intensity",
          "Hue", "OD280/OD315 of diluted wines", "Proline"]
data = urldownload(url, true, format=:CSV, header=header);