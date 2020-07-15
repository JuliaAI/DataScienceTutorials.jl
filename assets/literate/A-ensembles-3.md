<!--This file was generated, do not modify it.-->
# Simple example of a homogeneous ensemble using learning networks

In this simple example, no bagging is used, so every atomic model
gets the same learned parameters, unless the atomic model training
algorithm has randomness, eg, DecisionTree with random subsampling
of features at nodes.

Note that MLJ has a built in model wrapper called `EnsembleModel`
for creating bagged ensembles with a few lines of code.

## Definition of composite model type

```julia:ex1
using MLJ
using PyPlot
ioff() # hide
import Statistics
```

learning network (composite model spec):

```julia:ex2
Xs = source()
ys = source()

atom = @load DecisionTreeRegressor
atom.n_subfeatures = 4 # to ensure diversity among trained atomic models

machines = (machine(atom, Xs, ys) for i in 1:100)
```

overload `mean` for nodes:

```julia:ex3
Statistics.mean(v...) = mean(v)
Statistics.mean(v::AbstractVector{<:AbstractNode}) = node(mean, v...)

yhat = mean([predict(m, Xs) for  m in machines]);
```

new composite model type and instance:

```julia:ex4
one_hundred_models = @from_network OneHundredModels(atom=atom) <= yhat
```

## Application to data

```julia:ex5
X, y = @load_boston;
```

tune regularization parameter for a *single* tree:

```julia:ex6
r = range(atom,
          :min_samples_split,
          lower=2,
          upper=100, scale=:log)

mach = machine(atom, X, y)

curve = learning_curve!(mach,
                        range=r,
                        measure=mav,
                        resampling=CV(nfolds=9),
                        verbosity=0)

plot(curve.parameter_values, curve.measurements)
xlabel(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e1.svg")) # hide
```

\fig{e1.svg}

tune regularization parameter for all trees in ensemble simultaneously:

```julia:ex7
r = range(one_hundred_models,
          :(atom.min_samples_split),
          lower=2,
          upper=100, scale=:log)

mach = machine(one_hundred_models, X, y)

curve = learning_curve!(mach,
                        range=r,
                        measure=mav,
                        resampling=CV(nfolds=9),
                        verbosity=0)

plot(curve.parameter_values, curve.measurements)
xlabel(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e2.svg")) # hide
```

\fig{e2}

```julia:ex8
PyPlot.close_figs() # hide
```

