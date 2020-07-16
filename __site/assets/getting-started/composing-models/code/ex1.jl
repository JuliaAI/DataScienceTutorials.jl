# This file was generated, do not modify it. # hide
using MLJ
using PrettyPrinting
MLJ.color_off() # hide

@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];