# This file was generated, do not modify it. # hide
import MLJ.MLJBase.prefit
function prefit(ensemble::MyEnsemble, verbosity, X, y)

    Xs = source(X)
    ys = source(y)

    n = ensemble.n
    machines = (machine(:atom, Xs, ys) for i in 1:n)
    ys = [predict(m, Xs) for  m in machines]
    yhat = mean(ys)

    return (predict=yhat,)

end