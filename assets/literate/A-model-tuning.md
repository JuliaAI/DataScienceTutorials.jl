<!--This file was generated, do not modify it.-->
[MLJ.jl]: https://github.com/alan-turing-institute/MLJ.jl
[RDatasets.jl]: https://github.com/JuliaStats/RDatasets.jl
[NearestNeighbors.jl]: https://github.com/KristofferC/NearestNeighbors.jl

## Tuning a single hyperparameter

In MLJ, tuning is implemented as a model wrapper.
After wrapping a model in a _tuning strategy_ (e.g. cross-validation) and binding the wrapped model to data in a _machine_, fitting the machine initiates a search for optimal model hyperparameters.

Let's use a decision tree classifier and tune the maximum depth of the tree.
As usual, start by loading data and the model

```julia:ex1
using MLJ
X, y = @load_iris
@load DecisionTreeClassifier
```

### Specifying a range of value

To specify a range of value, you can use the `range` function:

```julia:ex2
dtc = DecisionTreeClassifier()
r   = range(dtc, :max_depth, lower=1, upper=5)
```

As you can see, the range function takes a model (`dtc`), a symbol for the hyperparameter of interest (`:max_depth`) and indication of how to samples values.
You can either manually specify an iterator over values by using the `values=` keyword or, where appropriate, use the `lower` and `upper` keywords which help define such an iterator between bounds.

Once a range of value has been defined, you can then wrap the model in a `TunedModel` specifying the tuning strategy:

```julia:ex3
tm = TunedModel(model=dtc, ranges=[r, ], measure=cross_entropy)
```

### Fitting and inspecting a tuned model

To fit a tuned model, you can use the usual syntax:

```julia:ex4
m = machine(tm, X, y)
fit!(m)
```

In order to inspect the best model, you can use the function `fitted_params` on the machine and inspect the `best_model` field:

```julia:ex5
fitted_params(m).best_model.max_depth
```

## Tuning nested hyperparameters

Let's generate simple dummy regression data

```julia:ex6
X = (x1=rand(100), x2=rand(100), x3=rand(100))
y = 2X.x1 - X.x2 + 0.05 * randn(100);
```

Let's then build a simple ensemble model with decision tree regressors:

```julia:ex7
dtr = @load DecisionTreeRegressor
forest = EnsembleModel(atom=dtr)
```

Such a model has *nested* hyperparameters in that the ensemble has hyperparameters (e.g. the `:bagging_fraction`) and the atom has hyperparameters (e.g. `:n_subfeatures` or `:max_depth`).

Range for nested hyperparameters are specified using dot syntax, the rest is done in much the same way as before:

```julia:ex8
r1 = range(forest, :(atom.n_subfeatures), lower=1, upper=3)
r2 = range(forest, :bagging_fraction, lower=0.4, upper=1.0)
tm = TunedModel(model=forest, tuning=Grid(resolution=12),
                resampling=CV(nfolds=6), ranges=[r1, r2],
                measure=rms)
m = machine(tm, X, y)
fit!(m);
```

A useful function to inspect a model after fitting it is the `report` function which collects information on the model and the tuning, for instance you can use it to recover the best measurement:

```julia:ex9
r = report(m)
r.best_measurement
```

