# This file was generated, do not modify it. # hide
DTR = @load DecisionTreeRegressor pkg=DecisionTree

y, X = unpack(df, ==(:price), col -> true)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=5)
tree = machine(DTR(), X, y)

fit!(tree, rows=train);