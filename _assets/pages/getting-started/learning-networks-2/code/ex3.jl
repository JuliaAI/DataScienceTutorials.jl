# This file was generated, do not modify it. # hide
std_model = Standardizer()
stand = machine(std_model, Xs)
W = transform(stand, Xs)

box_model = UnivariateBoxCoxTransformer()
box = machine(box_model, ys)
z = transform(box, ys)