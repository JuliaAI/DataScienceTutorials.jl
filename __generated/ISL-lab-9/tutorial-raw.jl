using MLJ
import RDatasets: dataset
using PrettyPrinting
using Random

Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

using Plots

ym1 = y .== -1
ym2 = .!ym1

scatter(X[ym1, 1], X[ym1, 2], markershape=:circle, label="y=-1")
scatter!(X[ym2, 1], X[ym2, 2], markershape=:cross, label="y=1")

plot!(legend=:bottomright, xlabel="X1", ylabel="X2", title="Scatter Plot", size=(800,600))

savefig(joinpath(@OUTPUT, "ISL-lab-9-g1.svg")); # You need to define @OUTPUT

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
