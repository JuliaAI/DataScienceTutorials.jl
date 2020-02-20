# This file was generated, do not modify it. # hide
Xs = source()
ys = source(kind=:target)

atom = @load DecisionTreeRegressor
atom.n_subfeatures = 4 # to ensure diversity among trained atomic models

machines = (machine(atom, Xs, ys) for i in 1:100)