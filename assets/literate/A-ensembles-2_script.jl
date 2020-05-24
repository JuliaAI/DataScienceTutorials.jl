# This file was generated, do not modify it.

using MLJ
using PyPlot
using PrettyPrinting
using StableRNGs
import DataFrames

MLJ.color_off() # hide
X, y = @load_boston
sch = schema(X)
p = length(sch.names)
n = sch.nrows
@show (n, p)
DataFrames.describe(y)

@load DecisionTreeRegressor

tree = machine(DecisionTreeRegressor(), X, y)
e = evaluate!(tree, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint # use PrettyPrinting

forest = EnsembleModel(atom=DecisionTreeRegressor())
forest.atom.n_subfeatures = 3

rng = StableRNG(5123) # for reproducibility
m = machine(forest, X, y)
r = range(forest, :n, lower=10, upper=1000)
curves = learning_curve!(m, resampling=Holdout(fraction_train=0.8, rng=rng),
                         range=r, measure=rms);

figure(figsize=(8,6))
plot(curves.parameter_values, curves.measurements)
xlabel("Number of trees", fontsize=14)
xticks([10, 250, 500, 750, 1000])
ylim([4, 5])

savefig(joinpath(@OUTPUT, "A-ensembles-2-curves.svg")) # hide

forest.n = 300;

params(forest) |> pprint

r_sf = range(forest, :(atom.n_subfeatures), lower=1, upper=12)
r_bf = range(forest, :bagging_fraction, lower=0.4, upper=1.0);

tuned_forest = TunedModel(model=forest,
                          tuning=Grid(resolution=3),
                          resampling=CV(nfolds=6, rng=StableRNG(32)),
                          ranges=[r_sf, r_bf],
                          measure=rms)
m = machine(tuned_forest, X, y)
e = evaluate!(m, resampling=Holdout(fraction_train=0.8),
              measure=[rms, rmslp1])
e |> pprint

r = report(m)

figure(figsize=(8,6))

res = r.plotting

vals_sf = res.parameter_values[:, 1]
vals_bf = res.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, res.measurements)
xticks(1:3:12, fontsize=12)
xlabel("Number of sub-features", fontsize=14)
yticks(0.4:0.2:1, fontsize=12)
ylabel("Bagging fraction", fontsize=14)

savefig(joinpath(@OUTPUT, "A-ensembles-2-heatmap.svg")) # hide

ŷ = predict(m, X)
rms(ŷ, y)

PyPlot.close_figs() # hide

