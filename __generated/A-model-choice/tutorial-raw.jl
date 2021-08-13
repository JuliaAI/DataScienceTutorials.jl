# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-model-choice/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-model-choice/Manifest.toml).
# For instance, copy these files to a folder 'A-model-choice', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/A-model-choice/Project.toml")
Pkg.update()

using RDatasets
using MLJ

iris = dataset("datasets", "iris")

first(iris, 3) |> pretty

iris2 = coerce(iris, :PetalWidth => OrderedFactor)
first(iris2[:, [:PetalLength, :PetalWidth]], 1) |> pretty

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

linreg = @load LinearRegressor pkg=GLM

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

