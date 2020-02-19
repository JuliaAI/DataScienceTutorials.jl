# This file was generated, do not modify it. # hide
@load DecisionTreeRegressor pkg=DecisionTree

boston = dataset("MASS", "Boston")

y, X = unpack(boston, ==(:MedV), col -> true)

train, test = partition(eachindex(y), 0.5, shuffle=true, rng=551);

scitype(X)