# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/advanced/AMES/Project.toml")
Pkg.instantiate()

using MLJ
import DataFrames: DataFrame
import Statistics
MLJ.color_off() # hide

X, y = @load_reduced_ames
X = DataFrame(X)
@show size(X)
first(X, 3)

schema(X)

@show y[1:3]
scitype(y)

creg = ConstantRegressor()

mach = machine(creg, X, y)

train, test = partition(collect(eachindex(y)), 0.70, shuffle=true); # 70:30 split
fit!(mach, rows=train)
ŷ = predict(mach, rows=test);
ŷ[1:3]

ŷ = predict_mean(mach, rows=test)
ŷ[1:3]

rmsl(ŷ, y[test])

RidgeRegressor = @load RidgeRegressor pkg="MultivariateStats"
KNNRegressor = @load KNNRegressor

Xs = source(X)
ys = source(y)

hot = machine(OneHotEncoder(), Xs)

W = transform(hot, Xs)
z = log(ys)

knn   = machine(KNNRegressor(K=5), W, z)
ridge = machine(RidgeRegressor(lambda=2.5), W, z)

ẑ₁ = predict(knn, W)
ẑ₂ = predict(ridge, W)

ẑ = 0.3ẑ₁ + 0.7ẑ₂;

ŷ = exp(ẑ);

fit!(ŷ, rows=train);
preds = ŷ(rows=test);
rmsl(preds, y[test])

mutable struct BlendedRegressor <: DeterministicNetworkComposite
    knn_model
    ridge_model
    knn_weight::Float64
end

import MLJ.MLJBase.prefit
function prefit(model::BlendedRegressor, verbosity, X, y)
    Xs = source(X)
    ys = source(y)

    hot = machine(OneHotEncoder(), Xs)
    W = transform(hot, Xs)

    z = log(ys)

    knn = machine(:knn_model, W, z)
    ridge = machine(:ridge_model, W, z)
    ẑ = model.knn_weight * predict(knn, W) + (1.0 - model.knn_weight) * predict(ridge, W)

    ŷ = exp(ẑ)

    (predict=ŷ,)
end

blended = BlendedRegressor(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(blended, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(preds, y[test])

@show blended.knn_weight
@show blended.knn_model.K
@show blended.ridge_model.lambda

blended

k_range = range(blended, :(knn_model.K), lower=2, upper=100, scale=:log10)
l_range = range(blended, :(ridge_model.lambda), lower=1e-4, upper=10, scale=:log10)
w_range = range(blended, :(knn_weight), lower=0.1, upper=0.9)

ranges = [k_range, l_range, w_range]

tuned_blended = TunedModel(
    blended;
    tuning=Grid(resolution=7),
    resampling=CV(nfolds=6),
    ranges,
    measure=rmsl,
    acceleration=CPUThreads(),
)

mach = machine(tuned_blended, X, y)
fit!(mach, rows=train);

blended_best = fitted_params(mach).best_model
@show blended_best.knn_model.K
@show blended_best.ridge_model.lambda
@show blended_best.knn_weight

preds = predict(mach, rows=test)
rmsl(y[test], preds)
