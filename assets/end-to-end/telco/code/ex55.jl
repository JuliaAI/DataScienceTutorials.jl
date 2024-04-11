# This file was generated, do not modify it. # hide
p1 = :(model.evo_tree_classifier.eta)
p2 = :(model.evo_tree_classifier.max_depth)

r1 = range(iterated_pipe, p1, lower=-2, upper=-0.5, scale=x->10^x)
r2 = range(iterated_pipe, p2, lower=2, upper=6)