# This file was generated, do not modify it.

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

