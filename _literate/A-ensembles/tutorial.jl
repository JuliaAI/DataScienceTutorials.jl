using Pkg # hideall
Pkg.activate("_literate/A-ensembles/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;


# @@dropdown
# ## Preliminary steps
# @@
# @@dropdown-content
#
# Let's start by loading the relevant packages and generating some dummy data.

using MLJ
import DataFrames: DataFrame
using StableRNGs
MLJ.color_off() # hide

rng = StableRNG(512)
Xraw = rand(rng, 300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(rng, 300))
X = DataFrame(Xraw, :auto)

train, test = partition(eachindex(y), 0.7);

# Let's also load a simple model:

KNNRegressor = @load KNNRegressor
knn_model = KNNRegressor(K=10)

# As before, let's instantiate a machine that wraps the model and data:

knn = machine(knn_model, X, y)

# and fit it

fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
l2(ŷ, y[test]) # sum of squares loss

# The workflow above is equivalent to just calling `evaluate`:

evaluate(
    knn_model,
    X,
    y;
    resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
    measure=rms,
)


# ‎
# @@
# @@dropdown
# ## Homogenous ensembles
# @@
# @@dropdown-content
#
# MLJ offers basic support for ensembling such as
# [_bagging_](https://en.wikipedia.org/wiki/Bootstrap_aggregating).  Defining such an
# ensemble of simple "atomic" models is done via the `EnsembleModel` constructor:

ensemble_model = EnsembleModel(model=knn_model, n=20);

# where the `n=20` indicates how many models are present in the ensemble.
#

# @@dropdown
# ### Training and testing an ensemble
# @@
# @@dropdown-content
#
# Now that we've instantiated an ensemble, it can be trained and tested the same as any
# other model:

estimates = evaluate(ensemble_model, X, y, resampling=CV())
estimates

# here the implicit measure is the sum of squares loss (default for regressions). The
# `measurement` is the mean taken over the folds:

@show estimates.measurement[1]
@show mean(estimates.per_fold[1])

# Note that multiple measures can be specified jointly. Here only one measure is
# (implicitly) specified but we still have to select the corresponding results (whence the
# `[1]` for both the `measurement` and `per_fold`).
#

# ‎
# @@
# @@dropdown
# ### Systematic tuning
# @@
# @@dropdown-content
#
# Let's simultaneously tune the ensemble's `bagging_fraction` and the K-Nearest neighbour
# hyperparameter `K`. Since one of our models is a field of the other, we have nested
# hyperparameters:

ensemble_model

# To define a tuning grid, we construct ranges for the two parameters and collate these
# ranges:

B_range = range(
    ensemble_model,
    :bagging_fraction,
    lower=0.5,
    upper=1.0,)

#-

K_range = range(
    ensemble_model,
    :(model.K),
    lower=1,
    upper=20,
)

# The scale for a tuning grid is linear by default but can be specified to `:log10` for
# logarithmic ranges.  Now we have to define a `TunedModel` and fit it:

tm = TunedModel(
    model=ensemble_model,
    tuning=Grid(resolution=10), # 10x10 grid
    resampling=Holdout(fraction_train=0.8, rng=StableRNG(42)),
    ranges=[B_range, K_range],
)

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);

# Note the `rng=42` seeds the random number generator for reproducibility of this example.
#

# ‎
# @@
# @@dropdown
# ### Reporting results
# @@
# @@dropdown-content
#
# The best model can be accessed like so:

best_ensemble = fitted_params(tuned_ensemble).best_model
@show best_ensemble.model.K
@show best_ensemble.bagging_fraction

# The `report` method gives more detailed information on the tuning process:

r = report(tuned_ensemble)
keys(r)

# For instance, `r.plotting` contains details about the optimization you might use in a
# plot:

r.plotting

# Although for that we can  use a built-in plot recipe for `TunedModel`:

using Plots
plt = plot(tuned_ensemble)
gui()

#-

savefig(joinpath(@OUTPUT, "A-ensembles-plot.svg")) # hide

# \figalt{Hyperparameter tuning}{A-ensembles-plot.svg}
#
# Finally you can always just evaluate the model by reporting `l2` on the test set:

ŷ = predict(tuned_ensemble, rows=test)
@show l2(ŷ, y[test])

PyPlot.close_figs() # hide

# ‎
# @@

# ‎
# @@
