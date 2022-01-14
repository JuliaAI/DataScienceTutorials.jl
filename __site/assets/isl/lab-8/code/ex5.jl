# This file was generated, do not modify it. # hide
HotTreeClf = OneHotEncoder() |> DTC()

mdl = HotTreeClf
mach = machine(mdl, X, y)
fit!(mach);