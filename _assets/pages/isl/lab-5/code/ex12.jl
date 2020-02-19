# This file was generated, do not modify it. # hide
mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)
@show round.(rep.measurements.^2, digits=2)
@show argmin(rep.measurements)