# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/A-fit-predict/Project.toml")
Pkg.instantiate()

using MLJ
import Statistics
using PrettyPrinting
using StableRNGs

MLJ.color_off() # hide
X, y = @load_iris;

DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree
tree_model = DecisionTreeClassifier()

tree = machine(tree_model, X, y)

rng = StableRNG(566)
train, test = partition(eachindex(y), 0.7, shuffle=true, rng=rng)
test[1:3]

fit!(tree, rows=train)

fitted_params(tree) |> pprint

ŷ = predict(tree, rows=test)
@show ŷ[1]

ȳ = predict_mode(tree, rows=test)
@show ȳ[1]
@show mode(ŷ[1])

mce = cross_entropy(ŷ, y[test])
round(mce, digits=4)

v = [1, 2, 3, 4]
stand_model = UnivariateStandardizer()
stand = machine(stand_model, v)

fit!(stand)
w = transform(stand, v)
@show round.(w, digits=2)
@show mean(w)
@show std(w)

vv = inverse_transform(stand, w)
sum(abs.(vv .- v))
