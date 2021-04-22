# [MLJ.jl]: https://github.com/alan-turing-institute/MLJ.jl
# [RDatasets.jl]: https://github.com/JuliaStats/RDatasets.jl
# [NearestNeighbors.jl]: https://github.com/KristofferC/NearestNeighbors.jl
#
# ## Tuning a single hyperparameter
#
# In MLJ, tuning is implemented as a model wrapper.
# After wrapping a model in a _tuning strategy_ (e.g. cross-validation) and binding the wrapped model to data in a _machine_, fitting the machine initiates a search for optimal model hyperparameters.
#
# Let's use a decision tree classifier and tune the maximum depth of the tree.
# As usual, start by loading data and the model

using MLJ
using PrettyPrinting
MLJ.color_off() # hide
X, y = @load_iris
DTC = @load DecisionTreeClassifier pkg=DecisionTree

# ### Specifying a range of value
#
# To specify a range of value, you can use the `range` function:

dtc = DTC()
r   = range(dtc, :max_depth, lower=1, upper=5)

# As you can see, the range function takes a model (`dtc`), a symbol for the hyperparameter of interest (`:max_depth`) and indication of how to samples values.
# For hyperparameters of type `<:Real`, you should specify a range of values as done above.
# For hyperparameters of other type (e.g. `Symbol`), you should use the `values=...` keyword.
#
# Once a range of values has been defined, you can then wrap the model in a `TunedModel` specifying the tuning strategy.

tm = TunedModel(model=dtc, ranges=[r, ], measure=cross_entropy)

# Note that "wrapping a model in a tuning strategy" as above means creating a new "self-tuning" version of the model, `tuned_model = TunedModel(model=...)`, in which further key-word arguments specify:
# 1. the algorithm (a.k.a., tuning strategy) for searching the hyper-parameter space of the model (e.g., `tuning = Random(rng=123)` or `tuning = Grid(goal=100)`).
# 2. the resampling strategy, used to evaluate performance for each value of the hyper-parameters (e.g., `resampling=CV(nfolds=9, rng=123)` or `resampling=Holdout(fraction_train=0.7)`).
# 3. the measure (or measures) on which to base performance evaluations (and for reporting purposes) (e.g., `measure = rms` or `measures = [rms, mae]`).
# 4. the range, usually describing the "space" of hyperparameters to be searched (but more generally whatever extra information is required to complete the search specification, e.g., initial values in gradient-descent optimization).

# For more options do `?TunedModel`.

# ### Fitting and inspecting a tuned model
#
# To fit a tuned model, you can use the usual syntax:

m = machine(tm, X, y)
fit!(m)

# In order to inspect the best model, you can use the function `fitted_params` on the machine and inspect the `best_model` field:

fitted_params(m).best_model.max_depth

# Note that here we have tuned a probabilistic model and consequently used a probabilistic measure for the tuning.
# We could also have decided we only cared about the mode and the misclassification rate, to do this, just use `operation=predict_mode` in the tuned model:

tm = TunedModel(model=dtc, ranges=r, operation=predict_mode,
                measure=misclassification_rate)
m = machine(tm, X, y)
fit!(m)
fitted_params(m).best_model.max_depth

# Let's check the misclassification rate for the best model:

r = report(m)
r.best_history_entry.measurement[1]

# Anyone wants plots? of course:

using PyPlot
ioff() # hide
figure(figsize=(8,6))
res = r.plotting # contains all you need for plotting
plot(res.parameter_values, res.measurements, ls="none", marker="o")

xticks(1:5, fontsize=12)
yticks(fontsize=12)
xlabel("Maximum depth", fontsize=14)
ylabel("Misclassification rate", fontsize=14)
ylim([0, 1])

savefig(joinpath(@OUTPUT, "A-model-tuning-hpt.svg")) # hide

# \figalt{hyperparameter heatmap}{A-model-tuning-hpt}

# ## Tuning nested hyperparameters

# Let's generate simple dummy regression data

X = (x1=rand(100), x2=rand(100), x3=rand(100))
y = 2X.x1 - X.x2 + 0.05 * randn(100);

# Let's then build a simple ensemble model with decision tree regressors:

DTR = @load DecisionTreeRegressor pkg=DecisionTree
forest = EnsembleModel(atom=DTR())

# Such a model has *nested* hyperparameters in that the ensemble has hyperparameters (e.g. the `:bagging_fraction`) and the atom has hyperparameters (e.g. `:n_subfeatures` or `:max_depth`).
# You can see this by inspecting the parameters using `params`:

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
r.best_history_entry.measurement[1]

# Let's visualise this

figure(figsize=(8,6))

res = r.plotting

vals_sf = res.parameter_values[:, 1]
vals_bf = res.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, res.measurements)
xlabel("Number of sub-features", fontsize=14)
ylabel("Bagging fraction", fontsize=14)
xticks([1, 2, 3], fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "A-model-tuning-hm.svg")) # hide

# \figalt{Hyperparameter heatmap}{A-model-tuning-hm.svg}
PyPlot.close_figs() # hide
