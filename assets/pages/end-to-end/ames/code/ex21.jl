# This file was generated, do not modify it. # hide
function MLJ.fit(model::KNNRidgeBlend, verbosity::Int, X, y)
    Xs = source(X)
    ys = source(y, kind=:target)
    hot = machine(OneHotEncoder(), Xs)
    W = transform(hot, Xs)
    z = log(ys)
    ridge_model = model.ridge_model
    knn_model = model.knn_model
    ridge = machine(ridge_model, W, z)
    knn = machine(knn_model, W, z)
    # and finally
    ẑ = model.knn_weight * predict(knn, W) + (1.0 - model.knn_weight) * predict(ridge, W)
    ŷ = exp(ẑ)
    fit!(ŷ, verbosity=0)
    return fitresults(ŷ)
end