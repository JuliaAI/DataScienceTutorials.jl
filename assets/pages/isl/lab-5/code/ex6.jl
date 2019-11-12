# This file was generated, do not modify it. # hide
lrm = LinMod()
lr1 = machine(lrm, Xhp, y) # poly of degree 1 (line)
fit!(lr1, rows=train)

lrm.fs.features = [:hp1, :hp2] # poly of degree 2
lr2 = machine(lrm, Xhp, y)
fit!(lr2, rows=train)

lrm.fs.features = [:hp1, :hp2, :hp3] # poly of degree 3
lr3 = machine(lrm, Xhp, y)
fit!(lr3, rows=train)