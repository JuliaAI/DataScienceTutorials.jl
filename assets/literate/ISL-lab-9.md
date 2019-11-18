<!--This file was generated, do not modify it.-->
## Getting started

```julia:ex1
using MLJ, RDatasets, PrettyPrinting, Random
```

We start by generating a 2D cloud of points

```julia:ex2
Random.seed!(3203)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))

X = MLJ.table(X)
y = categorical(y);
```

Let's fit a SVM classifier

```julia:ex3
@load SVC pkg=LIBSVM

svc_mdl = SVC()
svc = machine(svc_mdl, X, y)

fit!(svc);
```

As usual we can check how it performs

```julia:ex4
ypred = predict(svc, X)
misclassification_rate(ypred, y)
```

Not bad.

### Basic tuning

As usual we could tune the model, for instance the penalty encoding the tradeoff between margin width and misclassification:

```julia:ex5
rc = range(svc_mdl, :cost, lower=0.1, upper=5)
tm = TunedModel(model=svc_mdl, ranges=[rc], tuning=Grid(resolution=10),
                resampling=CV(nfolds=3, rng=33), measure=misclassification_rate)
mtm = machine(tm, X, y)

fit!(mtm)

ypred = predict(mtm, X)
misclassification_rate(ypred, y)
```

You could also change the kernel etc.

