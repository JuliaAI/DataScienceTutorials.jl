# This file was generated, do not modify it. # hide
@load DecisionTreeRegressor

y, X = unpack(df, ==(:price), col -> true)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=5)

tree = machine(DecisionTreeRegressor(), X, y)

fit!(tree, rows=train);