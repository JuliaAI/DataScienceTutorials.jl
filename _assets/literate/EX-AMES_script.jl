# This file was generated, do not modify it.

using MLJ, PrettyPrinting, DataFrames, Statistics

X, y = @load_reduced_ames
X = DataFrame(X)
@show size(X)
first(X, 3) |> pretty

@show y[1:3]
scitype(y)

creg = ConstantRegressor()

cmach = machine(creg, X, y)

train, test = partition(eachindex(y), 0.70, shuffle=true); # 70:30 split
fit!(cmach, rows=train)
ŷ = predict(cmach, rows=test)
ŷ[1:3] |> pprint

ŷ = predict_mean(cmach, rows=test)
ŷ[1:3]

rmsl(ŷ, y[test])

@load RidgeRegressor pkg="MultivariateStats"
@load KNNRegressor

Xs = source(X)
ys = source(y, kind=:target)

hot = machine(OneHotEncoder(), Xs)

W = transform(hot, Xs)
z = log(ys);

knn   = machine(KNNRegressor(K=5), W, z)
ridge = machine(RidgeRegressor(lambda=2.5), W, z)

ẑ₁ = predict(ridge, W)
ẑ₂ = predict(knn, W)

ẑ = 0.3ẑ₁ + 0.7ẑ₂;

ŷ = exp(ẑ);

fit!(ŷ, rows=train)
ypreds = ŷ(rows=test)
rmsl(y[test], ypreds)

W = Xs |> OneHotEncoder()
z = ys |> log;

ẑ₁ = (W, z) |> KNNRegressor(K=5)
ẑ₂ = (W, z) |> RidgeRegressor(lambda=2.5);

ẑ = 0.3ẑ₁ + 0.7ẑ₂;

ŷ = exp(ẑ);

fit!(ŷ, rows=train)
rmsl(y[test], ŷ(rows=test))

mutable struct KNNRidgeBlend <: DeterministicNetwork
    knn_model::KNNRegressor
    ridge_model::RidgeRegressor
    knn_weight::Float64
end

function MLJ.fit(model::KNNRidgeBlend, verbosity::Int, X, y)
    Xs = source(X)
    ys = source(y, kind=:target)
    hot = machine(OneHotEncoder(), Xs)
    W = transform(hot, Xs)
    z = log(ys)
    ridge_model = model.ridge_model
    knn_model = model.knn_model
    ridge = machine(ridge_model, W, z)
    knn = machine(knn_model, W, z)
    # and finally
    ẑ = model.knn_weight * predict(knn, W) + (1.0 - model.knn_weight) * predict(ridge, W)
    ŷ = exp(ẑ)
    fit!(ŷ, verbosity=0)
    return fitresults(ŷ)
end

krb = KNNRidgeBlend(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(krb, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(y[test], preds)

@show krb.knn_weight
@show krb.knn_model.K
@show krb.ridge_model.lambda

params(krb) |> pprint

k_range = range(krb, :(knn_model.K), lower=2, upper=100, scale=:log10)
l_range = range(krb, :(ridge_model.lambda), lower=1e-4, upper=10, scale=:log10)
w_range = range(krb, :(knn_weight), lower=0.1, upper=0.9)

ranges = [k_range, l_range, w_range]

tuning = Grid(resolution=3)
resampling = CV(nfolds=6)

tm = TunedModel(model=krb, tuning=tuning, resampling=resampling,
                ranges=ranges, measure=rmsl)

mtm = machine(tm, X, y)
fit!(mtm, rows=train);

krb_best = fitted_params(mtm).best_model
@show krb_best.knn_model.K
@show krb_best.ridge_model.lambda
@show krb_best.knn_weight

preds = predict(mtm, rows=test)
rmsl(y[test], preds)

