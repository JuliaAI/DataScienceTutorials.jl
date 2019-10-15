# Before running this, make sure to instantiate the environment corresponding to
# [this `Project.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml)
# and [this `Manifest.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials.
#
# To do so, copy both files in a folder, start Julia in that folder and
#
# ```julia
# using Pkg
# Pkg.activate(".")
# Pkg.instantiate()
# ```

using MLJ, Statistics
X, y = @load_iris;

@load DecisionTreeClassifier

tree_model = DecisionTreeClassifier()
tree = machine(tree_model, X, y)

train, test = partition(eachindex(y), 0.7, shuffle=true)
test[1:3]

fit!(tree, rows=train)

tree.fitresult

ŷ = predict(tree, rows=test)
@show ŷ[1]

ȳ = predict_mode(tree, rows=test)
@show ȳ[1]
@show mode(ŷ[1])

mce = cross_entropy(ŷ, y[test]) |> mean
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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

