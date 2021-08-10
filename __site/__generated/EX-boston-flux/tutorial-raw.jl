# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-boston-flux/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/EX-boston-flux/Manifest.toml).
# For instance, copy these files to a folder 'EX-boston-flux', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/EX-boston-flux/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

import MLJFlux
import MLJ
import DataFrames: DataFrame
import Statistics
import Flux
using Random
using PyPlot


Random.seed!(11)

features, targets = MLJ.@load_boston
features = DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> MLJ.pretty

train, test = MLJ.partition(collect(eachindex(targets)), 0.70, rng=52)

mutable struct MyNetworkBuilder <: MLJFlux.Builder
    n1::Int #Number of cells in the first hidden layer
    n2::Int #Number of cells in the second hidden layer
end

function MLJFlux.build(model::MyNetworkBuilder, input_dims, output_dims)
    layer1 = Flux.Dense(input_dims, model.n1)
    layer2 = Flux.Dense(model.n1, model.n2)
    layer3 = Flux.Dense(model.n2, output_dims)
    return Flux.Chain(layer1, layer2, layer3)
end

myregressor = MyNetworkBuilder(20, 10)

nnregressor = MLJFlux.NeuralNetworkRegressor(builder=myregressor, epochs=10)

mach = MLJ.machine(nnregressor, features, targets)

MLJ.fit!(mach, rows=train, verbosity=3)

preds = MLJ.predict(mach, features[test, :])

print(preds[1:5])

nnregressor.epochs = 15

MLJ.fit!(mach, rows=train, verbosity=3)

nnregressor.batch_size = 2
MLJ.fit!(mach, rows=train, verbosity=3)

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



bs = MLJ.range(nnregressor, :batch_size, lower=1, upper=5)

tm = MLJ.TunedModel(model=nnregressor, ranges=[bs, ], measure=MLJ.l2)

m = MLJ.machine(tm, features, targets)

MLJ.fit!(m)

MLJ.fitted_params(m).best_model.batch_size

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
