# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/boston-flux/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

import MLJFlux
import MLJ
import DataFrames: DataFrame
import Statistics
import Flux
using Random

MLJ.color_off() # hide
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

function MLJFlux.build(model::MyNetworkBuilder, rng, n_in, n_out)
    init = Flux.glorot_uniform(rng)
    layer1 = Flux.Dense(n_in, model.n1, init=init)
    layer2 = Flux.Dense(model.n1, model.n2, init=init)
    layer3 = Flux.Dense(model.n2, n_out, init=init)
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

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.1) #hide

plot(curve.parameter_values, curve.measurements, yaxis=:log, legend=false)

xlabel!(curve.parameter_name)
ylabel!("l2-log")

savefig(joinpath(@OUTPUT, "EX-boston-flux-g1.svg")); # hide

bs = MLJ.range(nnregressor, :batch_size, lower=1, upper=5)

tm = MLJ.TunedModel(model=nnregressor, ranges=[bs, ], measure=MLJ.l2)

m = MLJ.machine(tm, features, targets)

MLJ.fit!(m)

MLJ.fitted_params(m).best_model.batch_size
