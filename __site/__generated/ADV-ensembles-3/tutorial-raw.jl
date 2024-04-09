using MLJ
import Statistics

DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
atom = DecisionTreeRegressor()

X = (; x=rand(5))
y = rand(5)

Xs = source(X)
ys = source(y)

mach1 = machine(atom, Xs, ys)
mach2 = machine(atom, Xs, ys)

y1 = predict(mach1, Xs)
y2 = predict(mach2, Xs)

yhat = mean([y1, y2])

fit!(yhat)
Xnew = (; x=rand(2))
yhat(Xnew)

n = 10
machines = (machine(atom, Xs, ys) for i in 1:n)
ys = [predict(m, Xs) for  m in machines]
yhat = mean(ys);

mutable struct MyEnsemble <: DeterministicNetworkComposite
    atom
    n::Int64
end

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

X, y = @load_boston;

r = range(
    atom,
    :min_samples_split,
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(atom, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
)

using Plots
plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

atom_rand = DecisionTreeRegressor(n_subfeatures=4)
forest = MyEnsemble(atom_rand, 100)

r = range(
    forest,
    :(atom.min_samples_split),
    lower=2,
    upper=100,
    scale=:log,
)

mach = machine(forest, X, y)

curve = learning_curve(
    mach,
    range=r,
    measure=mav,
    resampling=CV(nfolds=6),
    verbosity=0,
    acceleration_grid=CPUThreads(),
)

plot(curve.parameter_values, curve.measurements)
xlabel!(curve.parameter_name)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
