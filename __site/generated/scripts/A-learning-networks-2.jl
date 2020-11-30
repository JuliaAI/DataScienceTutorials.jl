# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Preliminary steps## Let's start as with the previous tutorial:
using MLJ
using StableRNGs
import DataFrames

@load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(6616) # for reproducibility
x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))
X = DataFrames.DataFrame(x1=x1, x2=x2, x3=x3)

test, train = partition(eachindex(y), 0.8);

# In this tutorial we will show how to generate a model from a network; there are two approaches:# * using the `@from_network` macro# * writing the model in full## the first approach should usually be the one considered as it's simpler.## Generating a model from a network allows subsequent composition of that network with other tasks and tuning of that network.## ## Using the `@from_network` macro## Let's define a simple network## _Input layer_
Xs = source(X)
ys = source(y)

# _First layer_
std_model = Standardizer()
stand = machine(std_model, Xs)
W = MLJ.transform(stand, Xs)

box_model = UnivariateBoxCoxTransformer()
box_mach = machine(box_model, ys)
z = MLJ.transform(box_mach, ys)

# _Second layer_
ridge_model = RidgeRegressor(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)

# _Output_
ŷ = inverse_transform(box_mach, ẑ)

# No fitting has been done thus far, we have just defined a sequence of operations.## As we show next, a learning network needs to be exported to create a new stand-alone model type. Instances of that type can be bound with data in a machine, which can then be evaluated, for example. Somewhat paradoxically, one can wrap a learning network in a certain kind of machine, called a learning network machine, before exporting it, and in fact, the export process actually requires us to do so. Since a composite model type does not yet exist, one constructs the machine using a "surrogate" model, whose name indicates the ultimate model supertype (Deterministic, Probabilistic, Unsupervised or Static). This surrogate model has no fields.
surrogate = Deterministic()
mach = machine(surrogate, Xs, ys; predict=ŷ)

fit!(mach)
predict(mach, X[test[1:5], :])

# To form a model out of that network is easy using the `@from_network` macro.## Having defined a learning network machine, mach, as above, the following code defines a new model subtype WrappedRegressor <: Supervised with a single field regressor
@from_network mach begin
    mutable struct CompositeModel
        regressor=ridge_model
    end
end

# The macro defines a constructor CompositeModel and attributes a name to the# different models; the ordering / connection between the nodes is inferred# from `ŷ` via the `<= ŷ`.## **Note**: had the model been probabilistic (e.g. `RidgeClassifier`) you would have needed to add `is_probabilistic=true` at the end.
cm = machine(CompositeModel(), X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8, rng=51),
                measure=rms)
round(res.measurement[1], sigdigits=3)

# ## Defining a model from scratch## An alternative to the `@from_network`, is to fully define a new model with its `fit` method:
mutable struct CompositeModel2 <: DeterministicNetwork
    std_model::Standardizer
    box_model::UnivariateBoxCoxTransformer
    ridge_model::RidgeRegressor
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
    fit!(mach, verbosity=verbosity - 1)
    return mach()
end

mdl = CompositeModel2(Standardizer(), UnivariateBoxCoxTransformer(),
                      RidgeRegressor(lambda=0.1))
cm = machine(mdl, X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8), measure=rms)
round(res.measurement[1], sigdigits=3)

# Either way you now have a constructor to a  model which can be used as a stand-alone object, tuned and composed as you would with any basic model.
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

