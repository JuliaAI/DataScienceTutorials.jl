# This file was generated, do not modify it. # hide
import MLJFlux.@builder
using Flux

builder = @builder Chain(
    Dense(n_in, 16, relu),
    Dropout(0.1; rng=rng),
    Dense(16, n_out),
)