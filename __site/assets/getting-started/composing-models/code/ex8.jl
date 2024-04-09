# This file was generated, do not modify it. # hide
mach = machine(RidgeRegressor(), Xcont, y) |> fit!
yhat - predict(mach, Xcont)