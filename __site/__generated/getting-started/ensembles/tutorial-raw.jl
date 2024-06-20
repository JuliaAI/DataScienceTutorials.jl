using MLJ
import DataFrames: DataFrame
using StableRNGs

rng = StableRNG(512)
Xraw = rand(rng, 300, 3)
y = exp.(Xraw[:,1] - Xraw[:,2] - 2Xraw[:,3] + 0.1*rand(rng, 300))
X = DataFrame(Xraw, :auto)

train, test = partition(eachindex(y), 0.7);

KNNRegressor = @load KNNRegressor
knn_model = KNNRegressor(K=10)

knn = machine(knn_model, X, y)

fit!(knn, rows=train)
ŷ = predict(knn, X[test, :]) # or use rows=test
l2(ŷ, y[test]) # sum of squares loss

evaluate(
    knn_model,
    X,
    y;
    resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
    measure=rms,
)

ensemble_model = EnsembleModel(model=knn_model, n=20);

estimates = evaluate(ensemble_model, X, y, resampling=CV())
estimates

@show estimates.measurement[1]
@show mean(estimates.per_fold[1])

ensemble_model

B_range = range(
    ensemble_model,
    :bagging_fraction,
    lower=0.5,
    upper=1.0,)

K_range = range(
    ensemble_model,
    :(model.K),
    lower=1,
    upper=20,
)

tm = TunedModel(
    model=ensemble_model,
    tuning=Grid(resolution=10), # 10x10 grid
    resampling=Holdout(fraction_train=0.8, rng=StableRNG(42)),
    ranges=[B_range, K_range],
)

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);

best_ensemble = fitted_params(tuned_ensemble).best_model
@show best_ensemble.model.K
@show best_ensemble.bagging_fraction

r = report(tuned_ensemble)
keys(r)

r.plotting

using Plots
plot(tuned_ensemble)

ŷ = predict(tuned_ensemble, rows=test)
@show l2(ŷ, y[test])

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
