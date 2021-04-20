# ## Preliminary steps
#
# Let's start by loading the relevant packages and generating some dummy data.

using MLJ
import DataFrames
import Statistics
using PrettyPrinting
using StableRNGs

MLJ.color_off() # hide

rng = StableRNG(512)
Xraw = rand(rng, 300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(rng, 300))
X = DataFrames.DataFrame(Xraw)

train, test = partition(eachindex(y), 0.7);

# Let's also load a simple model:

KNNR = @load KNNRegressor
knn_model = KNNR(K=10)

# As before, let's instantiate a machine that wraps the model and data:

knn = machine(knn_model, X, y)

# and fit it

fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
rms(ŷ, y[test])

# The few steps above are equivalent to just calling `evaluate!`:

evaluate!(knn, resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
          measure=rms) |> pprint

# ## Homogenous ensembles
#
# MLJ offers basic support for ensembling such as [_bagging_](https://en.wikipedia.org/wiki/Bootstrap_aggregating).
# Defining such an ensemble of simple "atomic" models is done via the `EnsembleModel` constructor:

ensemble_model = EnsembleModel(atom=knn_model, n=20);

# where the `n=20` indicates how many models are present in the ensemble.
#
# ### Training and testing an ensemble
#
# Now that we've instantiated an ensemble, it can be trained and tested the same as any other model:

ensemble = machine(ensemble_model, X, y)
estimates = evaluate!(ensemble, resampling=CV())
estimates |> pprint

# here the implicit measure is the `rms` (default for regressions). The `measurement` is the mean taken over the folds:

@show estimates.measurement[1]
@show mean(estimates.per_fold[1])

# Note that multiple measurements can be specified jointly. Here only on measurement is (implicitly) specified but we still have to select the corresponding results (whence the `[1]` for both  the `measurement` and `per_fold`).
#
# ### Systematic tuning
#
# Let's simultaneously tune the ensemble's `bagging_fraction` and the K-Nearest neighbour hyperparameter `K`. Since one of our models is  a field of the  other, we have nested hyperparameters:

params(ensemble_model) |> pprint

# To define a tuning grid, we construct ranges for the two parameters and collate these ranges:

B_range = range(ensemble_model, :bagging_fraction,
                lower=0.5, upper=1.0)
K_range = range(ensemble_model, :(atom.K),
                lower=1, upper=20);

# the scale for a tuning grid is linear by default but can be specified to `:log10` for logarithmic ranges.
# Now we have to define a `TunedModel` and fit it:

tm = TunedModel(model=ensemble_model,
                tuning=Grid(resolution=10), # 10x10 grid
                resampling=Holdout(fraction_train=0.8, rng=StableRNG(42)),
                ranges=[B_range, K_range])

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);

# Note the `rng=42` seeds the random number generator for reproducibility of this example.
#
# ### Reporting results
#
# The best model can be accessed like so:

best_ensemble = fitted_params(tuned_ensemble).best_model
@show best_ensemble.atom.K
@show best_ensemble.bagging_fraction

# The `report` method gives more detailed information on the tuning process:

r = report(tuned_ensemble);

# For instance, `r.measurements` are the measurements for all pairs of hyperparameters which you could visualise nicely:

using PyPlot

figure(figsize=(8,6))

res = r.plotting
vals_b = res.parameter_values[:, 1]
vals_k = res.parameter_values[:, 2]

tricontourf(vals_b, vals_k, res.measurements)
xticks(0.5:0.1:1, fontsize=12)
xlabel("Bagging fraction", fontsize=14)
yticks([1, 5, 10, 15, 20], fontsize=12)
ylabel("Number of neighbors - K", fontsize=14)

savefig(joinpath(@OUTPUT, "A-ensembles-heatmap.svg")) # hide

# \figalt{Hyperparameter heatmap}{A-ensembles-heatmap.svg}
#
# Finally you can always just evaluate the model by reporting `rms` on the test set:

ŷ = predict(tuned_ensemble, rows=test)
rms(ŷ, y[test])

PyPlot.close_figs() # hide
