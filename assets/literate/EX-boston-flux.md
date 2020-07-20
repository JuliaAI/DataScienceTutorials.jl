<!--This file was generated, do not modify it.-->
**Main author**: Ayush Shridhar (ayush-1506).

## Getting started

```julia:ex1
import MLJFlux
import MLJ
import DataFrames
import Statistics
import Flux
using Random
using PyPlot

MLJ.color_off() # hide
Random.seed!(11)
```

Loading the Boston dataset. Our aim will be to implement a
neural network regressor to predict the price of a house,
given a number of features.

```julia:ex2
features, targets = MLJ.@load_boston
features = DataFrames.DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> MLJ.pretty
```

Next obvious steps: partitioning into train and test set

```julia:ex3
train, test = MLJ.partition(MLJ.eachindex(targets), 0.70, rng=52)
```

Let us try to implement an Neural Network regressor using
Flux.jl. MLJFlux.jl provides an MLJ interface to the Flux.jl
deep learning framework. The package provides four essential
models: `NeuralNetworkRegressor, MultitargetNeuralNetworkRegressor,
NeuralNetworkClassifier` and `ImageClassifier`.

At the heart of these models is a neural network. This is specified using
the `builder` parameter. Creating a builder object consists of two steps:
Step 1: Creating a new struct inherited from `MLJFlux.Builder`. `MLJFlux.Builder`
is an abstract structure used for the purpose of dispatching. Suppose we define
a new struct called `MyNetworkBuilder`. This can contain any attribute required to
build the model later. (Step 2). Let's use Dense Neural Network with 2 hidden layers.

```julia:ex4
mutable struct MyNetworkBuilder <: MLJFlux.Builder
    n1::Int #Number of cells in the first hidden layer
    n2::Int #Number of cells in the second hidden layer
end
```

Step 2: Building the neural network from this object.
Extend the `MLJFlux.build` function. This takes in 3 arguments: The object of
`MyNetworkBuilder`, input dimension (ip) and output dimension (op).

```julia:ex5
function MLJFlux.build(model::MyNetworkBuilder, input_dims, output_dims)
    layer1 = Flux.Dense(input_dims, model.n1)
    layer2 = Flux.Dense(model.n1, model.n2)
    layer3 = Flux.Dense(model.n2, output_dims)
    return Flux.Chain(layer1, layer2, layer3)
end
```

With all definitions ready, let us create an object of this:

```julia:ex6
myregressor = MyNetworkBuilder(20, 10)
```

Since the boston dataset is a regression problem, we'll be using
`NeuralNetworkRegressor` here. One thing to remember is that
a `NeuralNetworkRegressor` object works seamlessly like any other
MLJ model: you can wrap it in an  MLJ `machine` and do anything
you'd do otherwise.

Let's start by defining our NeuralNetworkRegressor object, that takes `myregressor`
as it's parameter.

```julia:ex7
nnregressor = MLJFlux.NeuralNetworkRegressor(builder=myregressor, epochs=10)
```

Other parameters that NeuralNetworkRegressor takes can be found here:
https://github.com/alan-turing-institute/MLJFlux.jl#model-hyperparameters

`nnregressor` now acts like any other MLJ model. Let's try wrapping it in a
MLJ machine and calling `fit!, predict`.

```julia:ex8
mach = MLJ.machine(nnregressor, features, targets)
```

Let's fit this on the train set

```julia:ex9
MLJ.fit!(mach, rows=train, verbosity=3)
```

As we can see, the training loss decreases at each epoch, showing the the neural network
is gradually learning form the training set.

```julia:ex10
preds = MLJ.predict(mach, features[test, :])

print(preds[1:5])
```

Now let's retrain our model. One thing to remember is that retrainig may OR may not
re-initialize our neural network model parameters. For example, changing the number of
epochs to 15 will not causes the model to train to 15 epcohs, but just 5 additional
epochs.

```julia:ex11
nnregressor.epochs = 15

MLJ.fit!(mach, rows=train, verbosity=3)
```

You can always specify that you want to retrain the model from scratch using the force=true
parameter. (Look at documentation for `fit!` for more).

However, changing parameters such as batch_size will necessarily cause re-training from scratch.

```julia:ex12
nnregressor.batch_size = 2
MLJ.fit!(mach, rows=train, verbosity=3)
```

Another bit to remember here is that changing the optimiser doesn't cause retaining by default.
However, the `optimiser_changes_trigger_retraining` in NeuralNetworkRegressor can be toggled to
accomodate this. This allows one to modify the learning rate, for example, after an initial burn-in period.

```julia:ex13
# Inspecting out-of-sample loss as a function of epochs

r = MLJ.range(nnregressor, :epochs, lower=1, upper=30, scale=:log10)
curve = MLJ.learning_curve(nnregressor, features, targets,
                       range=r,
                       resampling=MLJ.Holdout(fraction_train=0.7),
                       measure=MLJ.l2)

figure(figsize=(8,6))

plt.plot(curve.parameter_values,
    curve.measurements)

yscale("log")
xlabel(curve.parameter_name)
ylabel("l2")

savefig(joinpath(@OUTPUT, "EX-boston-flux-g1.svg")) # hide
```

\figalt{BostonFlux1}{EX-boston-flux-g1.svg}

## Tuning

As mentioned above, `nnregressor` can act like any other MLJ model. Let's try to tune the
batch_size parameter.

```julia:ex14
bs = MLJ.range(nnregressor, :batch_size, lower=1, upper=5)

tm = MLJ.TunedModel(model=nnregressor, ranges=[bs, ], measure=MLJ.l2)
```

For more on tuning, refer to the model-tuning tutorial.

```julia:ex15
m = MLJ.machine(tm, features, targets)

MLJ.fit!(m)
```

This evaluated the model at each value of our range.
The best value is:

```julia:ex16
MLJ.fitted_params(m).best_model.batch_size
```

