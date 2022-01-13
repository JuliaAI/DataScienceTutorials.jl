# This file was generated, do not modify it. # hide
Xs = source()
ys = source()

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
atom = DecisionTreeRegressor()

machines = (machine(atom, Xs, ys) for i in 1:100)