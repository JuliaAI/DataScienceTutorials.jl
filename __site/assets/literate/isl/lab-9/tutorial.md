<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/isl/lab-9/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

@@dropdown
## Getting started
@@
@@dropdown-content

````julia:ex2
using MLJ
import RDatasets: dataset
using PrettyPrinting
using Random
MLJ.color_off() # hide
````

We start by generating a 2D cloud of points

````julia:ex3
Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))
````

which we can visualise

````julia:ex4
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

ym1 = y .== -1
ym2 = .!ym1

scatter(X[ym1, 1], X[ym1, 2], markershape=:circle, label="y=-1")
scatter!(X[ym2, 1], X[ym2, 2], markershape=:cross, label="y=1")

plot!(legend=:bottomright, xlabel="X1", ylabel="X2", title="Scatter Plot", size=(800,600))

savefig(joinpath(@OUTPUT, "ISL-lab-9-g1.svg")); # You need to define @OUTPUT
````

\figalt{Toy points}{ISL-lab-9-g1.svg}

let's wrap the data as a table:

````julia:ex5
X = MLJ.table(X)
y = categorical(y);
````

and fit a SVM classifier

````julia:ex6
SVC = @load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);
````

As usual we can check how it performs

````julia:ex7
ypred = MLJ.predict(svc, X)
misclassification_rate(ypred, y)
````

Not bad.

@@dropdown
### Basic tuning
@@
@@dropdown-content

As usual we could tune the model, for instance the penalty encoding the tradeoff between margin width and misclassification:

````julia:ex8
rc = range(svc_mdl, :cost, lower=0.1, upper=5)
tm = TunedModel(model=svc_mdl, ranges=[rc], tuning=Grid(resolution=10),
                resampling=CV(nfolds=3, rng=33), measure=misclassification_rate)
mtm = machine(tm, X, y)

fit!(mtm)

ypred = MLJ.predict(mtm, X)
misclassification_rate(ypred, y)
````

You could also change the kernel etc.

‎
@@

‎
@@

