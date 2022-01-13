# This file was generated, do not modify it. # hide
mutable struct KNNRidgeBlend <: DeterministicComposite
    knn_model::KNNRegressor
    ridge_model::RidgeRegressor
    knn_weight::Float64
end