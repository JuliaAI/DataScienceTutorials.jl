# This file was generated, do not modify it.

using Pkg# hideall
Pkg.activate("_literate/A-model-tuning/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end

using MLJ
using PrettyPrinting
MLJ.color_off() # hide
X, y = @load_iris
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree

dtc = DecisionTreeClassifier()
r   = range(dtc, :max_depth, lower=1, upper=5)

tm = TunedModel(model=dtc, ranges=[r, ], measure=cross_entropy)

m = machine(tm, X, y)
fit!(m)

fitted_params(m).best_model.max_depth

tm = TunedModel(model=dtc, ranges=r, operation=predict_mode,
                measure=misclassification_rate)
m = machine(tm, X, y)
fit!(m)
fitted_params(m).best_model.max_depth

r = report(m)
r.best_history_entry.measurement[1]

using PyPlot
ioff() # hide
figure(figsize=(8,6))
res = r.plotting # contains all you need for plotting
plot(res.parameter_values, res.measurements, ls="none", marker="o")

xticks(1:5, fontsize=12)
yticks(fontsize=12)
xlabel("Maximum depth", fontsize=14)
ylabel("Misclassification rate", fontsize=14)
ylim([0, 1])

savefig(joinpath(@OUTPUT, "A-model-tuning-hpt.svg")) # hide

X = (x1=rand(100), x2=rand(100), x3=rand(100))
y = 2X.x1 - X.x2 + 0.05 * randn(100);

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
forest = EnsembleModel(model=DecisionTreeRegressor())

params(forest) |> pprint

r1 = range(forest, :(model.n_subfeatures), lower=1, upper=3)
r2 = range(forest, :bagging_fraction, lower=0.4, upper=1.0)
tm = TunedModel(model=forest, tuning=Grid(resolution=12),
                resampling=CV(nfolds=6), ranges=[r1, r2],
                measure=rms)
m = machine(tm, X, y)
fit!(m);

r = report(m)
r.best_history_entry.measurement[1]

figure(figsize=(8,6))

res = r.plotting

vals_sf = res.parameter_values[:, 1]
vals_bf = res.parameter_values[:, 2]

tricontourf(vals_sf, vals_bf, res.measurements)
xlabel("Number of sub-features", fontsize=14)
ylabel("Bagging fraction", fontsize=14)
xticks([1, 2, 3], fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "A-model-tuning-hm.svg")) # hide

PyPlot.close_figs() # hide

