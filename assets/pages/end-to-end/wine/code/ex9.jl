# This file was generated, do not modify it. # hide
stand = machine(Standardizer(), Xc)
fit!(stand)
Xcs = transform(stand, Xc);