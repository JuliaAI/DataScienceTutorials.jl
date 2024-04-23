<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/getting-started/ensembles/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

@@dropdown
## Preliminary steps
@@
@@dropdown-content

Let's start by loading the relevant packages and generating some dummy data.

````julia:ex2
using MLJ
import DataFrames: DataFrame
using StableRNGs
MLJ.color_off() # hide

rng = StableRNG(512)
Xraw = rand(rng, 300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(rng, 300))
X = DataFrame(Xraw, :auto)

train, test = partition(eachindex(y), 0.7);
````

Let's also load a simple model:

````julia:ex3
KNNRegressor = @load KNNRegressor
knn_model = KNNRegressor(K=10)
````

As before, let's instantiate a machine that wraps the model and data:

````julia:ex4
knn = machine(knn_model, X, y)
````

and fit it

````julia:ex5
fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
l2(ŷ, y[test]) # sum of squares loss
````

The workflow above is equivalent to just calling `evaluate`:

````julia:ex6
evaluate(
    knn_model,
    X,
    y;
    resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
    measure=rms,
)
````

‎
@@
@@dropdown
## Homogenous ensembles
@@
@@dropdown-content

MLJ offers basic support for ensembling such as
[_bagging_](https://en.wikipedia.org/wiki/Bootstrap_aggregating).  Defining such an
ensemble of simple "atomic" models is done via the `EnsembleModel` constructor:

````julia:ex7
ensemble_model = EnsembleModel(model=knn_model, n=20);
````

where the `n=20` indicates how many models are present in the ensemble.

@@dropdown
### Training and testing an ensemble
@@
@@dropdown-content

Now that we've instantiated an ensemble, it can be trained and tested the same as any
other model:

````julia:ex8
estimates = evaluate(ensemble_model, X, y, resampling=CV())
estimates
````

here the implicit measure is the sum of squares loss (default for regressions). The
`measurement` is the mean taken over the folds:

````julia:ex9
@show estimates.measurement[1]
@show mean(estimates.per_fold[1])
````

Note that multiple measures can be specified jointly. Here only one measure is
(implicitly) specified but we still have to select the corresponding results (whence the
`[1]` for both the `measurement` and `per_fold`).

‎
@@
@@dropdown
### Systematic tuning
@@
@@dropdown-content

Let's simultaneously tune the ensemble's `bagging_fraction` and the K-Nearest neighbour
hyperparameter `K`. Since one of our models is a field of the other, we have nested
hyperparameters:

````julia:ex10
ensemble_model
````

To define a tuning grid, we construct ranges for the two parameters and collate these
ranges:

````julia:ex11
B_range = range(
    ensemble_model,
    :bagging_fraction,
    lower=0.5,
    upper=1.0,)
````

````julia:ex12
K_range = range(
    ensemble_model,
    :(model.K),
    lower=1,
    upper=20,
)
````

The scale for a tuning grid is linear by default but can be specified to `:log10` for
logarithmic ranges.  Now we have to define a `TunedModel` and fit it:

````julia:ex13
tm = TunedModel(
    model=ensemble_model,
    tuning=Grid(resolution=10), # 10x10 grid
    resampling=Holdout(fraction_train=0.8, rng=StableRNG(42)),
    ranges=[B_range, K_range],
)

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);
````

Note the `rng=42` seeds the random number generator for reproducibility of this example.

‎
@@
@@dropdown
### Reporting results
@@
@@dropdown-content

The best model can be accessed like so:

````julia:ex14
best_ensemble = fitted_params(tuned_ensemble).best_model
@show best_ensemble.model.K
@show best_ensemble.bagging_fraction
````

The `report` method gives more detailed information on the tuning process:

````julia:ex15
r = report(tuned_ensemble)
keys(r)
````

For instance, `r.plotting` contains details about the optimization you might use in a
plot:

````julia:ex16
r.plotting
````

Although for that we can also use a built-in plot recipe for `TunedModel`:

````julia:ex17
using Plots
plot(tuned_ensemble)
````

````julia:ex18
savefig(joinpath(@OUTPUT, "A-ensembles-plot.svg")); # hide
````

\figalt{Hyperparameter tuning}{A-ensembles-plot.svg}

Finally you can always just evaluate the model by reporting `l2` on the test set:

````julia:ex19
ŷ = predict(tuned_ensemble, rows=test)
@show l2(ŷ, y[test])
````

‎
@@

‎
@@

