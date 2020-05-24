# [MLJ.jl]: https://github.com/alan-turing-institute/MLJ.jl
# [RDatasets.jl]: https://github.com/JuliaStats/RDatasets.jl
# [MLJModels.jl]: https://github.com/alan-turing-institute/MLJModels.jl
# [DecisionTree.jl]: https://github.com/bensadeghi/DecisionTree.jl
# [NearestNeighbors.jl]: https://github.com/KristofferC/NearestNeighbors.jl
# [GLM.jl]: https://github.com/JuliaStats/GLM.jl
# [ScikitLearn.jl]: https://github.com/cstjean/ScikitLearn.jl
# ## Data and its interpretation
#
# ### Machine type and scientific type

using RDatasets
using MLJ
MLJ.color_off() # hide
iris = dataset("datasets", "iris")

first(iris, 3) |> pretty

# Observe that below each column name there are two _types_ given: the first one is the _machine type_ and the second one is the _scientific type_.
#
# * **machine type**: is the Julia type the data is currently encoded as, for instance `Float64`,
# * **scientific type**: is a type corresponding to how the data should be _interpreted_, for instance `Multiclass{3}`.
#
# If you want to specify a different scientific type than the one inferred, you can do so by using the function `coerce` along with pairs of column names and scientific types:

iris2 = coerce(iris, :PetalWidth => OrderedFactor)
first(iris2[:, [:PetalLength, :PetalWidth]], 1) |> pretty

# ### Unpacking data
#
# The function `unpack` helps specify the target and the input for a regression or classification task

y, X = unpack(iris, ==(:Species), colname -> true)
first(X, 1) |> pretty

# The two arguments after the dataframes should be understood as _functions_ over column names specifying the target and the input data respectively.
# Let's look in more details at what we used here:
#
# * `==(:Species)` is a shorthand to specify that the target should be the column with name equal to `:Species`,
# * `colname -> true` indicates that every other column is to be taken as input
#
# Let's try another one:

y, X = unpack(iris, ==(:Species), !=(:PetalLength))
first(X, 1) |> pretty

# You can also use the shorthand `@load_iris` for such common examples:

X, y = @load_iris;

# ## Choosing a model
#
# ### Model search
#
# In MLJ, a _model_ is a struct storing the _hyperparameters_ of the learning algorithm indicated by the struct name (and only that).
#
# A number of models are available in MLJ, usually thanks to external packages interfacing with MLJ (see also `[MLJModels.jl]`).
# In order to see which ones are appropriate for the data you have and its scientific interpretation, you can use the function `models` along with the function `matching`; let us look specifically at models which support a probabilistic output:

for m in models(matching(X, y))
    if m.prediction_type == :probabilistic
        println(rpad(m.name, 30), "($(m.package_name))")
    end
end

# ### Loading a model
#
# Most models are implemented outside of the MLJ ecosystem; you therefore have to _load models_ using the `@load` command.
#
# **Note**: you _must_ have the package from which the model is loaded available in your environment (in this case `[DecisionTree.jl]`) otherwise MLJ will not be able to load the model.
#
# For instance, let's say you want to fit a K-Nearest Neighbours classifier:

knc = @load KNeighborsClassifier

# In some cases, there may be several packages offering the same model, for instance `LinearRegressor` is offered by both `[GLM.jl]` and `[ScikitLearn.jl]` so you will need to specify the package you would like to use by adding `pkg="ThePackage"` in the load command:

linreg = @load LinearRegressor pkg="GLM"
