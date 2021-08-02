# This file was generated, do not modify it. # hide
function MLJFlux.build(model::MyNetworkBuilder, input_dims, output_dims)
    layer1 = Flux.Dense(input_dims, model.n1)
    layer2 = Flux.Dense(model.n1, model.n2)
    layer3 = Flux.Dense(model.n2, output_dims)
    return Flux.Chain(layer1, layer2, layer3)
end