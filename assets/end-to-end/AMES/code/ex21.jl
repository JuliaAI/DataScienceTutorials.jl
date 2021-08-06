# This file was generated, do not modify it. # hide
mutable struct KNNRidgeBlend <: DeterministicNetwork
    knn_model::KNNRegressor
    ridge_model::RidgeRegressor
    knn_weight::Float64
end