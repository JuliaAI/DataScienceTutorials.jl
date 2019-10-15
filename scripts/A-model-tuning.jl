# Before running this, make sure to instantiate the environment corresponding to
# [this `Project.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml)
# and [this `Manifest.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials.
#
# To do so, copy both files in a folder, start Julia in that folder and
#
# ```julia
# using Pkg
# Pkg.activate(".")
# Pkg.instantiate()
# ```

using MLJ
X, y = @load_iris
@load DecisionTreeClassifier

dtc = DecisionTreeClassifier()
r   = range(dtc, :max_depth, lower=1, upper=5)

tm = TunedModel(model=dtc, ranges=[r, ], measure=cross_entropy)

m = machine(tm, X, y)
fit!(m)

fitted_params(m).best_model.max_depth

X = (x1=rand(100), x2=rand(100), x3=rand(100))
y = 2X.x1 - X.x2 + 0.05 * randn(100);

dtr = @load DecisionTreeRegressor
forest = EnsembleModel(atom=dtr)

r1 = range(forest, :(atom.n_subfeatures), lower=1, upper=3)
r2 = range(forest, :bagging_fraction, lower=0.4, upper=1.0)
tm = TunedModel(model=forest, tuning=Grid(resolution=12),
                resampling=CV(nfolds=6), ranges=[r1, r2],
                measure=rms)
m = machine(tm, X, y)
fit!(m);

r = report(m)
r.best_measurement

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

