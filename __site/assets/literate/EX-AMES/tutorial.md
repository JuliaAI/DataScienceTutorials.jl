<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/EX-AMES/Project.toml")
Pkg.instantiate()
````

Build a model for the Ames House Price data set using a simple learning network to blend
their predictions of two regressors.

@@dropdown
## Baby steps
@@
@@dropdown-content

Let's load a reduced version of the well-known Ames House Price data set (containing six
of the more important categorical features and six of the more important numerical
features).  The dataset can be loaded directly with `@load_ames` and the reduced version
via `@load_reduced_ames`.

````julia:ex2
using MLJ
import DataFrames: DataFrame
import Statistics
MLJ.color_off() # hide

X, y = @load_reduced_ames
X = DataFrame(X)
@show size(X)
first(X, 3)
````

````julia:ex3
schema(X)
````

The target is a continuous vector:

````julia:ex4
@show y[1:3]
scitype(y)
````

So this is a standard regression problem with a mix of categorical and continuous input.

‎

‎
@@
@@dropdown
## Dummy model
@@
@@dropdown-content

Remember that a "model" in MLJ is just a container for hyperparameters; let's take a
particularly simple one: constant regression.

````julia:ex5
creg = ConstantRegressor()
````

Wrapping the model in data creates a *machine* which will store training outcomes
(*fit-results*)

````julia:ex6
mach = machine(creg, X, y)
````

You can now train the machine specifying the data it should be trained on (if
unspecified, all the data will be used);

````julia:ex7
train, test = partition(collect(eachindex(y)), 0.70, shuffle=true); # 70:30 split
fit!(mach, rows=train)
ŷ = predict(mach, rows=test);
ŷ[1:3]
````

Observe that the output is probabilistic, each element is a univariate normal
distribution (with the same mean and variance as it's a constant model).

You can recover deterministic output by either computing the mean of predictions or
using `predict_mean` directly (the `mean` function can be applied to any distribution
from [`Distributions.jl`](https://github.com/JuliaStats/Distributions.jl)):

````julia:ex8
ŷ = predict_mean(mach, rows=test)
ŷ[1:3]
````

You can then call any loss function from
[StatisticalMeasures.jl](https://juliaai.github.io/StatisticalMeasures.jl/dev/) to
assess the quality of the model by comparing the performances on the test set:

````julia:ex9
rmsl(ŷ, y[test])
````

‎

‎
@@
@@dropdown
## KNN-Ridge blend
@@
@@dropdown-content

Let's try something a bit fancier than a constant regressor.

* one-hot-encode categorical inputs
* log-transform the target
* fit both a KNN regression and a Ridge regression on the data
* Compute a weighted average of individual model predictions
* inverse transform (exponentiate) the blended prediction

We are going to combine all this into a single new stand-alone composite model type,
which will start by building and testing a [learning
network](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_networks/#Learning-Networks).

````julia:ex10
RidgeRegressor = @load RidgeRegressor pkg="MultivariateStats"
KNNRegressor = @load KNNRegressor
````

@@dropdown
### A learning network
@@
@@dropdown-content

Let's start by defining the source nodes of the network, which will wrap our data. Here
we are including data only for testing purposes. Later when we "export" our functioning
network, we'll remove reference to the data.

````julia:ex11
Xs = source(X)
ys = source(y)
````

In our first "layer", there's one-hot encoder and a log transformer; these will
respectively lead to new nodes `W` and `z`:

````julia:ex12
hot = machine(OneHotEncoder(), Xs)

W = transform(hot, Xs)
z = log(ys)
````

In the second "layer", there's a KNN regressor and a ridge regressor, these lead to nodes
`ẑ₁` and `ẑ₂`

````julia:ex13
knn   = machine(KNNRegressor(K=5), W, z)
ridge = machine(RidgeRegressor(lambda=2.5), W, z)

ẑ₁ = predict(knn, W)
ẑ₂ = predict(ridge, W)
````

In the third "layer", there's a weighted combination of the two regression models:

````julia:ex14
ẑ = 0.3ẑ₁ + 0.7ẑ₂;
````

And finally we need to invert the initial transformation of the target (which was a log):

````julia:ex15
ŷ = exp(ẑ);
````

You've now defined the learning network we need, which we test like this:

````julia:ex16
fit!(ŷ, rows=train);
preds = ŷ(rows=test);
rmsl(preds, y[test])
````

While that's essentially all we need to solve our problem, we'll go one step further,
exporting our learning network as a stand-alone model type we can apply to any data set,
and treat like any other type. In particular, this will make tuning the (nested) model
hyperparameters easier.

‎

‎
@@
@@dropdown
### Exporting the learning network
@@
@@dropdown-content

Here's the struct for our new model type. Notice it has other models as hyperparameters.

````julia:ex17
mutable struct BlendedRegressor <: DeterministicNetworkComposite
    knn_model
    ridge_model
    knn_weight::Float64
end
````

Note the supertype `DeterministicNetworkComposite` here, which we are using because our
composite model will always make deterministic predictions, and because we are exporting
a learning network to make our new composite model. Refer to documentation for other
options here.

The other step we need is to wrap our learning network in a `prefit` definition,
substituting the component models we used with symbol "placeholders" with names
corresponding to fields of our new struct. We'll also use the `knn_weight` field of our
struct to set the mix, instead of hard-coding it as we did above.

````julia:ex18
import MLJ.MLJBase.prefit
function prefit(model::BlendedRegressor, verbosity, X, y)
    Xs = source(X)
    ys = source(y)

    hot = machine(OneHotEncoder(), Xs)
    W = transform(hot, Xs)

    z = log(ys)

    knn = machine(:knn_model, W, z)
    ridge = machine(:ridge_model, W, z)
    ẑ = model.knn_weight * predict(knn, W) + (1.0 - model.knn_weight) * predict(ridge, W)

    ŷ = exp(ẑ)

    (predict=ŷ,)
end
````

We can now instantiate and fit such a model:

````julia:ex19
blended = BlendedRegressor(KNNRegressor(K=5), RidgeRegressor(lambda=2.5), 0.3)
mach = machine(blended, X, y)
fit!(mach, rows=train)

preds = predict(mach, rows=test)
rmsl(preds, y[test])
````

‎

‎
@@
@@dropdown
### Tuning the blended model
@@
@@dropdown-content

Before we get started, it's important to note that the hyperparameters of the model have
different levels of *nesting*. This becomes explicit when trying to access elements:

````julia:ex20
@show blended.knn_weight
@show blended.knn_model.K
@show blended.ridge_model.lambda
````

You can see what names to use here from the way the model instance is displayed:

````julia:ex21
blended
````

The range of values to do your hyperparameter tuning over should follow the nesting
structure reflected by `params`:

````julia:ex22
k_range = range(blended, :(knn_model.K), lower=2, upper=100, scale=:log10)
l_range = range(blended, :(ridge_model.lambda), lower=1e-4, upper=10, scale=:log10)
w_range = range(blended, :(knn_weight), lower=0.1, upper=0.9)

ranges = [k_range, l_range, w_range]
````

Now there remains to define how the tuning should be done. Let's just specify a coarse
grid tuning with cross validation and instantiate a tuned model:

````julia:ex23
tuned_blended = TunedModel(
    blended;
    tuning=Grid(resolution=7),
    resampling=CV(nfolds=6),
    ranges,
    measure=rmsl,
    acceleration=CPUThreads(),
)
````

For more tuning options, see [the
docs](https://alan-turing-institute.github.io/MLJ.jl/dev/tuning_models/).

Now `tuned_blended` is a "self-tuning" version of the original model, with all the
necessary resampling occurring under the hood. You can think of wrapping a model in
`TunedModel` as moving the tuned hyperparameters to *learned* parameters.

````julia:ex24
mach = machine(tuned_blended, X, y)
fit!(mach, rows=train);
````

To retrieve the best model, you can use:

````julia:ex25
blended_best = fitted_params(mach).best_model
@show blended_best.knn_model.K
@show blended_best.ridge_model.lambda
@show blended_best.knn_weight
````

you can also use `mach` to make predictions (which will be done using the best model,
trained on *all* the `train` data):

````julia:ex26
preds = predict(mach, rows=test)
rmsl(y[test], preds)
````

‎
@@

‎
@@

