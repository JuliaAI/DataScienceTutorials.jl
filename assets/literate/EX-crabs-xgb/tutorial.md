<!--This file was generated, do not modify it.-->
```julia:ex1
using Pkg # hideall
Pkg.activate("_literate/EX-crabs-xgb/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
```

This example is inspired from [this post](https://www.analyticsvidhya.com/blog/2016/03/complete-guide-parameter-tuning-xgboost-with-codes-python/) showing how to use XGBoost.

## First steps

Again, the crabs dataset is so common that there is a  simple load function for it:

```julia:ex2
using MLJ
using StatsBase
using Random
using PyPlot
ioff() # hide
using CategoricalArrays
using PrettyPrinting
import DataFrames

MLJ.color_off() # hide
X, y = @load_crabs
X = DataFrames.DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3) |> pretty
```

It's a classification problem with the following classes:

```julia:ex3
levels(y) |> pprint
```

Note that the dataset is currently sorted by target, let's shuffle it to avoid the obvious issues this may cause

```julia:ex4
Random.seed!(523)
perm = randperm(length(y))
X = X[perm,:]
y = y[perm];
```

It's not a very big dataset so we will likely overfit it badly using something as sophisticated as XGBoost but it will do for a demonstration.

```julia:ex5
train, test = partition(collect(eachindex(y)), 0.70, shuffle=true, rng=52)
XGBC = @load XGBoostClassifier
xgb_model = XGBC()
```

Let's check whether the training and  is balanced, `StatsBase.countmap` is useful for that:

```julia:ex6
countmap(y[train]) |> pprint
```

which is pretty balanced. You could check the same on the test set and full set and the same comment would still hold.

## XGBoost machine

Wrap a machine around an XGBoost model (XGB) and the data:

```julia:ex7
xgb  = XGBC()
xgbm = machine(xgb, X, y)
```

We will tune it varying the number of rounds used and generate a learning curve

```julia:ex8
r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve(xgbm, range=r, resolution=50,
                        measure=L1HingeLoss())
```

Let's have a look

```julia:ex9
figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("HingeLoss", fontsize=14)
xticks([10, 100, 200, 500], fontsize=12)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-curve1.svg")) # hide
```

\figalt{Cross entropy vs Num Round}{EX-crabs-xgb-curve1.svg}

So, in short, using more rounds helps. Let's arbitrarily fix it to 200.

```julia:ex10
xgb.num_round = 200;
```

### More tuning (1)

Let's now tune the maximum depth of each tree and the minimum child weight in the boosting.

```julia:ex11
r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)
```

Great, as always we can investigate the tuning by using `report` and can, for instance, plot a heatmap of the measurements:

```julia:ex12
r = report(mtm)

res = r.plotting

md = res.parameter_values[:,1]
mcw = res.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, res.measurements)

xlabel("Maximum tree depth", fontsize=14)
ylabel("Minimum child weight", fontsize=14)
xticks(3:2:10, fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-heatmap.svg")) # hide
```

\figalt{Hyperparameter heatmap}{EX-crabs-xgb-heatmap.svg}

Let's extract the optimal model and inspect its parameters:

```julia:ex13
xgb = fitted_params(mtm).best_model
@show xgb.max_depth
@show xgb.min_child_weight
```

### More tuning (2)

Let's examine the effect of `gamma`:

```julia:ex14
xgbm = machine(xgb, X, y)
r = range(xgb, :gamma, lower=0, upper=10)
curve = learning_curve!(xgbm, range=r, resolution=30,
                        measure=cross_entropy);
```

it looks like the `gamma` parameter substantially affects model performance:

```julia:ex15
@show round(minimum(curve.measurements), sigdigits=3)
@show round(maximum(curve.measurements), sigdigits=3)
```

### More tuning (3)

Let's examine the effect of `subsample` and `colsample_bytree`:

```julia:ex16
r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)
tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=234), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)
```

and the usual procedure to visualise it:

```julia:ex17
r = report(mtm)

res = r.plotting

ss = res.parameter_values[:,1]
cbt = res.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(ss, cbt, res.measurements)

xlabel("Sub sample", fontsize=14)
ylabel("Col sample by tree", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "EX-crabs-xgb-heatmap2.svg")) # hide
```

\figalt{Hyperparameter heatmap}{EX-crabs-xgb-heatmap2.svg}

Let's retrieve the best models:

```julia:ex18
xgb = fitted_params(mtm).best_model
@show xgb.subsample
@show xgb.colsample_bytree
```

We could continue with more fine tuning but given how small the dataset is, it doesn't make much sense.
How does it fare on the test set?

```julia:ex19
PyPlot.close_figs() # hide
ŷ = predict_mode(mtm, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)
```

