using Pkg # hideall
Pkg.activate("_literate/A-ensembles-3/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# Illustration of learning networks to create homogeneous ensemble using learning
# networks.

# Learning networks are an advanced MLJ feature which are covered in detail, with
# examples, in the [Learning
# networks](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_networks/) section
# of the manual. In the "Ensemble" and "Ensemble (2)" tutorials it is shown how to create
# and apply homogeneous ensembles using MLJ's built-in `EnsembleModel` wrapper. To provide
# a simple illustration of learning networks we show how a user could build their own
# ensemble wrapper. We simplify the illustration by excluding bagging, which means all
# randomness has to be generated by the atomic models themselves (e.g., by the random
# selection of features in each split of a decision tree).

# For a more advanced illustration, see the "Stacking" tutorial.

# Some familiarity with the early parts of [Learning networks by
# example](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_networks/#Learning-networks-by-example)
# will be helpful, but is not essential.


# ## Definition of composite model type



using MLJ
import Statistics

# We load a model type we might want to use as an atomic model in our ensemble, and
# instantiate a default instance:

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
atom = DecisionTreeRegressor()

# We'll be able to change this later on if we want.

# The standard workflow for defining a new composite model type using learning networks is
# in two stages:

# 1. Define and test a learning network using some small test data set

# 2. "Export" the network as a new stand-alone model type, unattached to any data

# Here's a small data set we can use for step 1:

X = (; x=rand(5))
y = rand(5)

# As a warm-up exercise, we'll suppose we have only two models in the ensemble.  We start
# by wrapping the input data in source nodes. These nodes will be interface points for new
# training data when we `fit!` our new ensemble model type; `Xs` will also be an interface
# point for production data when we call `predict` on our new ensemble model type.

Xs = source(X)
ys = source(y)

# Here are two distinct machines (for learning distinct trees) that share the same atomic
# model (hyperparameters):

mach1 = machine(atom, Xs, ys)
mach2 = machine(atom, Xs, ys)

# Here are prediction nodes:

y1 = predict(mach1, Xs)
y2 = predict(mach2, Xs)

# It happens that `mean` immediately works on vectors of nodes, because `+` and division
# by a scalar works for nodes:

yhat = mean([y1, y2])

# Let's test the network:

fit!(yhat)
Xnew = (; x=rand(2))
yhat(Xnew)

# Great. No issues. Here's how we have an ensemble of any size:

n = 10
machines = (machine(atom, Xs, ys) for i in 1:n)
ys = [predict(m, Xs) for  m in machines]
yhat = mean(ys);

# You can go ahead and test the modified network as before.

# We define a struct for our new ensemble type:

mutable struct MyEnsemble <: DeterministicNetworkComposite
    atom
    n::Int64
end

# Note carefully the supertype `DeterministicNetworkComposite`, which we are using because our
# atomic model will always be `Deterministic` predictors, and we are exporting a learning
# network to make a new composite model. Refer to documentation for other options here.

# Finally, we wrap our learning network in a `prefit` method. In
# this case we leave out the test data, and substitute the actual `atom` we used with a
# symbolic "placeholder", with the name of the corresponding model field, in this case
# `:atom`:

import MLJ.MLJBase.prefit
function prefit(ensemble::MyEnsemble, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    n = ensemble.n
    machines = (machine(:atom, Xs, ys) for i in 1:n)
    ys = [predict(m, Xs) for  m in machines]
    yhat = mean(ys)

    # the returned interface indicates the node that will produce output for predict
    return (predict=yhat,)
end



# ## Application to data



X, y = @load_boston;

# Here's a learning curve for the `min_samples_split` parameter of a *single* tree:

r = range(
    atom,
    :min_samples_split,
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(atom, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
)

using Plots
plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e1.svg")) # hide

# \fig{e1.svg}

# We'll now generate a similar curve for a 100-tree ensemble of tree but this time we'll
# make sure to make the atom random:

atom_rand = DecisionTreeRegressor(n_subfeatures=4)
forest = MyEnsemble(atom_rand, 100)

r = range(
    forest,
    :(atom.min_samples_split),
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(forest, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
    acceleration_grid=CPUThreads(),
)

plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

savefig(joinpath(@OUTPUT, "e2.svg")) # hide

# \fig{e2}

#-


