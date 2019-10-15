# This file was generated, do not modify it. # hide
using MLJ, PrettyPrinting

@load KNNRegressor
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
height = [178, 194, 165, 173, 168];
