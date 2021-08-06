# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/ISL-lab-9/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import RDatasets: dataset
using PrettyPrinting
using Random
MLJ.color_off() # hide

Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

using PyPlot
ioff() # hide
figure(figsize=(8,6))

ym1 = y .== -1
ym2 = .!ym1
plot(X[ym1, 1], X[ym1, 2], ls="none", marker="o")
plot(X[ym2, 1], X[ym2, 2], ls="none", marker="x")

savefig(joinpath(@OUTPUT, "ISL-lab-9-g1.svg")) # hide

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

PyPlot.close_figs() # hide

