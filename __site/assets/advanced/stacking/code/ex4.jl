# This file was generated, do not modify it. # hide
mutable struct MyAverageTwo <: DeterministicNetworkComposite
    regressor1
    regressor2
end

import MLJ.MLJBase.prefit
function prefit(::MyAverageTwo, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    m1 = machine(:regressor1, Xs, ys)
    y1 = predict(m1, Xs)

    m2 = machine(:regressor2, Xs, ys)
    y2 = predict(m2, Xs)

    yhat = 0.5*y1 + 0.5*y2

    return (predict=yhat,)
end