using MLJ
using PrettyPrinting
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

using Plots

plot(m, size=(800,600))

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

plot(m)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
