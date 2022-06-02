# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-ensembles-3/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-ensembles-3/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# # Simple example of a homogeneous ensemble using learning networks

# In this simple example, no bagging is used, so every atomic model
# gets the same learned parameters, unless the atomic model training
# algorithm has randomness, eg, DecisionTree with random subsampling
# of features at nodes.

# Note that MLJ has a built in model wrapper called `EnsembleModel`
# for creating bagged ensembles with a few lines of code.

# ## Definition of composite model type

using MLJ
using PyPlot
import Statistics

# Defining the learning network (composite model spec):

Xs = source()
ys = source()

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
atom = DecisionTreeRegressor()

machines = (machine(atom, Xs, ys) for i in 1:100)

# Overloading `mean` for nodes:

Statistics.mean(v...) = mean(v)
Statistics.mean(v::AbstractVector{<:AbstractNode}) = node(mean, v...)

yhat = mean([predict(m, Xs) for  m in machines]);

# Defining the new composite model type and instance:

surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=yhat)

@from_network mach begin
    mutable struct OneHundredModels
        atom=atom
    end
end

one_hundred_models = OneHundredModels()

# ## Application to data

X, y = @load_boston;

# tune regularization parameter for a *single* tree:

r = range(atom,
          :min_samples_split,
          lower=2,
          upper=100, scale=:log)

mach = machine(atom, X, y)

figure()
curve = learning_curve!(mach,
                        range=r,
                        measure=mav,
                        resampling=CV(nfolds=9),
                        verbosity=0)

plot(curve.parameter_values, curve.measurements)
xlabel(curve.parameter_name)

# \fig{e1.svg}

# tune regularization parameter for all trees in ensemble simultaneously:

r = range(one_hundred_models,
          :(atom.min_samples_split),
          lower=2,
          upper=100, scale=:log)

mach = machine(one_hundred_models, X, y)

figure()
curve = learning_curve!(mach,
                        range=r,
                        measure=mav,
                        resampling=CV(nfolds=9),
                        verbosity=0)
plot(curve.parameter_values, curve.measurements)
xlabel(curve.parameter_name)

# \fig{e2}

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

