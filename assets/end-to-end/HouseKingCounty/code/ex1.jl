# This file was generated, do not modify it. # hide
using MLJ, PrettyPrinting, DataFrames, Statistics, CSV, Dates
using PyPlot, HTTP
MLJ.color_off() # hide

req = HTTP.get("https://raw.githubusercontent.com/bbrandom91/KC_Housing/master/kc_house_data.csv")

df = CSV.read(req.body, missingstring="NA")
describe(df)