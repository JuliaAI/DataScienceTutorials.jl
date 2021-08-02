# This file was generated, do not modify it. # hide
mtm = machine(tm, Xhp, y)
fit!(mtm)
rep = report(mtm)

res = rep.plotting

@show round.(res.measurements.^2, digits=2)
@show argmin(res.measurements)