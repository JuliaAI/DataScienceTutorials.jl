using MLJ
using StableRNGs
import DataFrames: DataFrame
Ridge = @load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(6616) # for reproducibility
x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))
X = DataFrame(x1=x1, x2=x2, x3=x3)

test, train = partition(eachindex(y), 0.8);

Xs = source(X)
ys = source(y)

std_model = Standardizer()
stand = machine(std_model, Xs)
W = transform(stand, Xs)

box_model = UnivariateBoxCoxTransformer()
box_mach = machine(box_model, ys)
z = transform(box_mach, ys)

ridge_model = Ridge(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)

ŷ = inverse_transform(box_mach, ẑ)

surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=ŷ)

fit!(mach)
predict(mach, X[test[1:5], :])

@from_network mach begin
    mutable struct CompositeModel
        regressor=ridge_model
    end
end

cm = machine(CompositeModel(), X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8, rng=51),
                measure=rms)
round(res.measurement[1], sigdigits=3)

mutable struct CompositeModel2 <: DeterministicComposite
    std_model::Standardizer
    box_model::UnivariateBoxCoxTransformer
    ridge_model::Ridge
end

function MLJ.fit(m::CompositeModel2, verbosity::Int, X, y)
    Xs = source(X)
    ys = source(y)
    W = MLJ.transform(machine(m.std_model, Xs), Xs)
    box = machine(m.box_model, ys)
    z = MLJ.transform(box, ys)
    ẑ = predict(machine(m.ridge_model, W, z), W)
    ŷ = inverse_transform(box, ẑ)
    mach = machine(Deterministic(), Xs, ys; predict=ŷ)
    return!(mach, m, verbosity - 1)
end

mdl = CompositeModel2(Standardizer(), UnivariateBoxCoxTransformer(),
                      Ridge(lambda=0.1))
cm = machine(mdl, X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8), measure=rms)
round(res.measurement[1], sigdigits=3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

