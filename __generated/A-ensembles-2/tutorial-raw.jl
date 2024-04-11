using MLJ
using PrettyPrinting
using StableRNGs
import DataFrames: DataFrame, describe

X, y = @load_boston
sch = schema(X)
p = length(sch.names)
describe(y)  # From DataFrames

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree

tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e

forest = EnsembleModel(model=DecisionTreeRegressor())
forest.model.n_subfeatures = 3

rng = StableRNG(5123) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve(m, resampling=Holdout(fraction_train=0.8, rng=rng),
                         range=r, measure=rms);

using Plots

plot(curves.parameter_values, curves.measurements,
xticks = [10, 100, 250, 500, 750, 1000],
size=(800,600), linewidth=2, legend=false)
xlabel!("Number of trees")
ylabel!("Root Mean Squared error")

forest.n = 150;

params(forest) |> pprint

r_sf = range(forest, :(model.n_subfeatures), lower=1, upper=12)
r_bf = range(forest, :bagging_fraction, lower=0.4, upper=1.0);

tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=StableRNG(32)),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e

plot(m)

ŷ = predict(m, X)
@show rms(ŷ, y)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
