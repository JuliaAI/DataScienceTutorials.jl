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

using RDatasets, MLJ
iris = dataset("datasets", "iris")

first(iris, 3) |> pretty

iris2 = coerce(iris, :PetalWidth => OrderedFactor)
first(iris2[[:PetalLength, :PetalWidth]], 1) |> pretty

y, X = unpack(iris, ==(:Species), colname -> true)
first(X, 1) |> pretty

y, X = unpack(iris, ==(:Species), !=(:PetalLength))
first(X, 1) |> pretty

X, y = @load_iris;

for m in models(matching(X, y))
    if m.prediction_type == :probabilistic
        println(rpad(m.name, 30), "($(m.package_name))")
    end
end

knc = @load KNeighborsClassifier

linreg = @load LinearRegressor pkg="GLM"

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

