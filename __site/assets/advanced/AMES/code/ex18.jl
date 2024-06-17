# This file was generated, do not modify it. # hide
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