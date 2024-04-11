# This file was generated, do not modify it. # hide
mutable struct BlendedRegressor <: DeterministicNetworkComposite
    knn_model
    ridge_model
    knn_weight::Float64
end