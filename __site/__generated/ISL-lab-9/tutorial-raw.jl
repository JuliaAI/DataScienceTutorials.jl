using MLJ
import RDatasets: dataset
using PrettyPrinting
using Random

Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

using PyPlot
figure(figsize=(8,6))

ym1 = y .== -1
ym2 = .!ym1
plot(X[ym1, 1], X[ym1, 2], ls="none", marker="o")
plot(X[ym2, 1], X[ym2, 2], ls="none", marker="x")

X = MLJ.table(X)
y = categorical(y);

SVC = @load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);

ypred = MLJ.predict(svc, X)
misclassification_rate(ypred, y)

rc = range(svc_mdl, :cost, lower=0.1, upper=5)
tm = TunedModel(model=svc_mdl, ranges=[rc], tuning=Grid(resolution=10),
                resampling=CV(nfolds=3, rng=33), measure=misclassification_rate)
mtm = machine(tm, X, y)

fit!(mtm)

ypred = MLJ.predict(mtm, X)
misclassification_rate(ypred, y)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

