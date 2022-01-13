using MLJ
import DataFrames: DataFrame
using PrettyPrinting
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
rms(ŷ, y[test])

evaluate!(knn, resampling=Holdout(fraction_train=0.7, rng=StableRNG(666)),
          measure=rms)

ensemble_model = EnsembleModel(model=knn_model, n=20);

ensemble = machine(ensemble_model, X, y)
estimates = evaluate!(ensemble, resampling=CV())
estimates

@show estimates.measurement[1]
@show mean(estimates.per_fold[1])

params(ensemble_model) |> pprint

B_range = range(ensemble_model, :bagging_fraction,
                lower=0.5, upper=1.0)
K_range = range(ensemble_model, :(model.K),
                lower=1, upper=20);

tm = TunedModel(model=ensemble_model,
                tuning=Grid(resolution=10), # 10x10 grid
                resampling=Holdout(fraction_train=0.8, rng=StableRNG(42)),
                ranges=[B_range, K_range])

tuned_ensemble = machine(tm, X, y)
fit!(tuned_ensemble, rows=train);

best_ensemble = fitted_params(tuned_ensemble).best_model
@show best_ensemble.model.K
@show best_ensemble.bagging_fraction

r = report(tuned_ensemble);

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

ŷ = predict(tuned_ensemble, rows=test)
@show rms(ŷ, y[test])

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

