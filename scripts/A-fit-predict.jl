# Before running this, make sure to activate the environment corresponding to
# [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml)
# and update it so that you get an environment which matches the one used to generate
# the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the Project.toml
# using Pkg
# Pkg.activate(".")
# Pkg.update()
# ```

using MLJ, Statistics, PrettyPrinting
X, y = @load_iris;

@load DecisionTreeClassifier

tree_model = DecisionTreeClassifier()
tree = machine(tree_model, X, y)

train, test = partition(eachindex(y), 0.7, shuffle=true)
test[1:3]

fit!(tree, rows=train)

tree.fitresult |> pprint

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

