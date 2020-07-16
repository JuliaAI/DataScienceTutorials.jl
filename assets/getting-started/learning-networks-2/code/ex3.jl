# This file was generated, do not modify it. # hide
std_model = Standardizer()
stand = machine(std_model, Xs)
W = MLJ.transform(stand, Xs)

box_model = UnivariateBoxCoxTransformer()
box_mach = machine(box_model, ys)
z = MLJ.transform(box_mach, ys)