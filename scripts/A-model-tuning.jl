# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# [MLJ.jl]: https://github.com/alan-turing-institute/MLJ.jl# [RDatasets.jl]: https://github.com/JuliaStats/RDatasets.jl# [NearestNeighbors.jl]: https://github.com/KristofferC/NearestNeighbors.jl## ## Tuning a single hyperparameter## In MLJ, tuning is implemented as a model wrapper.# After wrapping a model in a _tuning strategy_ (e.g. cross-validation) and binding the wrapped model to data in a _machine_, fitting the machine initiates a search for optimal model hyperparameters.## Let's use a decision tree classifier and tune the maximum depth of the tree.# As usual, start by loading data and the model
using MLJ, PrettyPrinting
X, y = @load_iris
@load DecisionTreeClassifier

# ### Specifying a range of value## To specify a range of value, you can use the `range` function:
dtc = DecisionTreeClassifier()
r   = range(dtc, :max_depth, lower=1, upper=5)

# As you can see, the range function takes a model (`dtc`), a symbol for the hyperparameter of interest (`:max_depth`) and indication of how to samples values.# For hyperparameters of type `<:Real`, you should specify a range of values as done above.# For hyperparameters of other type (e.g. `Symbol`), you should use the `values=...` keyword.## Once a range of values has been defined, you can then wrap the model in a `TunedModel` specifying the tuning strategy:
tm = TunedModel(model=dtc, ranges=[r, ], measure=cross_entropy)

# ### Fitting and inspecting a tuned model## To fit a tuned model, you can use the usual syntax:
m = machine(tm, X, y)
fit!(m)

# In order to inspect the best model, you can use the function `fitted_params` on the machine and inspect the `best_model` field:
fitted_params(m).best_model.max_depth

# Note that here we have tuned a probabilistic model and consequently used a probabilistic measure for the tuning.# We could also have decided we only cared about the mode and the misclassification rate, to do this, just use `operation=predict_mode` in the tuned model:
tm = TunedModel(model=dtc, ranges=r, operation=predict_mode,
                measure=misclassification_rate)
m = machine(tm, X, y)
fit!(m)
fitted_params(m).best_model.max_depth

# In this case it doesn't the hyperparameter but it could have.# Let's check the misclassification rate for the best model:
r = report(m)
r.best_measurement

# ## Tuning nested hyperparameters
# Let's generate simple dummy regression data
X = (x1=rand(100), x2=rand(100), x3=rand(100))
y = 2X.x1 - X.x2 + 0.05 * randn(100);

# Let's then build a simple ensemble model with decision tree regressors:
dtr = @load DecisionTreeRegressor
forest = EnsembleModel(atom=dtr)

# Such a model has *nested* hyperparameters in that the ensemble has hyperparameters (e.g. the `:bagging_fraction`) and the atom has hyperparameters (e.g. `:n_subfeatures` or `:max_depth`).# You can see this by inspecting the parameters using `params`:
params(forest) |> pprint

# Range for nested hyperparameters are specified using dot syntax, the rest is done in much the same way as before:
r1 = range(forest, :(atom.n_subfeatures), lower=1, upper=3)
r2 = range(forest, :bagging_fraction, lower=0.4, upper=1.0)
tm = TunedModel(model=forest, tuning=Grid(resolution=12),
                resampling=CV(nfolds=6), ranges=[r1, r2],
                measure=rms)
m = machine(tm, X, y)
fit!(m);

# A useful function to inspect a model after fitting it is the `report` function which collects information on the model and the tuning, for instance you can use it to recover the best measurement:
r = report(m)
r.best_measurement

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

