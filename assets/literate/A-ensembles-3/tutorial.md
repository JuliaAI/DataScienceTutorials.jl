<!--This file was generated, do not modify it.-->
```julia:ex1
using Pkg # hideall
Pkg.activate("_literate/A-ensembles-3/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
```

# Simple example of a homogeneous ensemble using learning networks

In this simple example, no bagging is used, so every atomic model
gets the same learned parameters, unless the atomic model training
algorithm has randomness, eg, DecisionTree with random subsampling
of features at nodes.

Note that MLJ has a built in model wrapper called `EnsembleModel`
for creating bagged ensembles with a few lines of code.

## Definition of composite model type

```julia:ex2
using MLJ
using PyPlot
ioff() # hide
import Statistics
```

Defining the learning network (composite model spec):

```julia:ex3
Xs = source()
ys = source()

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
atom = DecisionTreeRegressor()

machines = (machine(atom, Xs, ys) for i in 1:100)
```

Overloading `mean` for nodes:

```julia:ex4
Statistics.mean(v...) = mean(v)
Statistics.mean(v::AbstractVector{<:AbstractNode}) = node(mean, v...)

yhat = mean([predict(m, Xs) for  m in machines]);
```

Defining the new composite model type and instance:

```julia:ex5
surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=yhat)

@from_network mach begin
    mutable struct OneHundredModels
        atom=atom
    end
end

one_hundred_models = OneHundredModels()
```

## Application to data

```julia:ex6
X, y = @load_boston;
```

tune regularization parameter for a *single* tree:

```julia:ex7
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

```julia:ex8
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

```julia:ex9
PyPlot.close_figs() # hide
```

