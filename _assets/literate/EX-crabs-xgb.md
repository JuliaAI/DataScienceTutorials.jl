<!--This file was generated, do not modify it.-->
This example is inspired from [this post](https://www.analyticsvidhya.com/blog/2016/03/complete-guide-parameter-tuning-xgboost-with-codes-python/) showing how to use XGBoost.

## First steps

Again, the crabs dataset is so common that there is a  simple load function for it:

```julia:ex1
using MLJ, StatsBase, Random, PyPlot, CategoricalArrays
using PrettyPrinting, DataFrames, LossFunctions
X, y = @load_crabs
X = DataFrame(X)
@show size(X)
@show y[1:3]
first(X, 3) |> pretty
```

It's a classification problem with the following classes:

```julia:ex2
levels(y) |> pprint
```

It's not a very big dataset so we will likely overfit it badly using something as sophisticated as XGBoost but it will do for a demonstration.

```julia:ex3
train, test = partition(eachindex(y), 0.70, shuffle=true, rng=52)
@load XGBoostClassifier
xgb_model = XGBoostClassifier()
```

Let's check whether the training and  is balanced, `StatsBase.countmap` is useful for that:

```julia:ex4
countmap(y[train]) |> pprint
```

which is pretty balanced. You could check the same on the test set and full set and the same comment would still hold.

## XGBoost machine

Wrap a machine around an XGBoost model (XGB) and the data:

```julia:ex5
xgb  = XGBoostClassifier()
xgbm = machine(xgb, X, y)
```

We will tune it varying the number of rounds used and generate a learning curve

```julia:ex6
r = range(xgb, :num_round, lower=50, upper=500)
curve = learning_curve!(xgbm, resampling=CV(nfolds=3),
                        range=r, resolution=50,
                        measure=HingeLoss())
```

Let's have a look

```julia:ex7
figure(figsize=(8,6))
plot(curve.parameter_values, curve.measurements)
xlabel("Number of rounds", fontsize=14)
ylabel("Cross entropy", fontsize=14)
xticks([10, 100, 200, 500], fontsize=12)
yticks(1.46:0.005:1.475, fontsize=12)

savefig("assets/literate/EX-crabs-xgb-curve1.svg") # hide
```

![Cross entropy vs Num Round](/assets/literate/EX-crabs-xgb-curve1.svg)

So, in short, using more rounds helps. Let's arbitrarily fix it to 200.

```julia:ex8
xgb.num_round = 200;
```

### More tuning (1)

Let's now tune the maximum depth of each tree and the minimum child weight in the boosting.

```julia:ex9
r1 = range(xgb, :max_depth, lower=3, upper=10)
r2 = range(xgb, :min_child_weight, lower=0, upper=5)

tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=11), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)
```

Great, as always we can investigate the tuning by using `report` and can, for instance, plot a heatmap of the measurements:

```julia:ex10
r = report(mtm)

md = r.parameter_values[:,1]
mcw = r.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(md, mcw, r.measurements)

xlabel("Maximum tree depth", fontsize=14)
ylabel("Minimum child weight", fontsize=14)
xticks(3:2:10, fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/EX-crabs-xgb-heatmap.svg") # hide
```

![Hyperparameter heatmap](/assets/literate/EX-crabs-xgb-heatmap.svg)

Let's extract the optimal model and inspect its parameters:

```julia:ex11
xgb = fitted_params(mtm).best_model
@show xgb.max_depth
@show xgb.min_child_weight
```

### More tuning (2)

Let's examine the effect of `gamma`:

```julia:ex12
xgbm = machine(xgb, X, y)
r = range(xgb, :gamma, lower=0, upper=10)
curve = learning_curve!(xgbm, resampling=CV(),
                        range=r, resolution=30,
                        measure=cross_entropy);
```

actually it doesn't look like it's changing much...:

```julia:ex13
@show round(minimum(curve.measurements), sigdigits=3)
@show round(maximum(curve.measurements), sigdigits=3)
```

### More tuning (3)

Let's examine the effect of `subsample` and `colsample_bytree`:

```julia:ex14
r1 = range(xgb, :subsample, lower=0.6, upper=1.0)
r2 = range(xgb, :colsample_bytree, lower=0.6, upper=1.0)
tm = TunedModel(model=xgb, tuning=Grid(resolution=8),
                resampling=CV(rng=234), ranges=[r1,r2],
                measure=cross_entropy)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)
```

and the usual procedure to visualise it:

```julia:ex15
r = report(mtm)
ss = r.parameter_values[:,1]
cbt = r.parameter_values[:,2]

figure(figsize=(8,6))
tricontourf(ss, cbt, r.measurements)

xlabel("Sub sample", fontsize=14)
ylabel("Col sample by tree", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/EX-crabs-xgb-heatmap2.svg") # hide
```

![Hyperparameter heatmap](/assets/literate/EX-crabs-xgb-heatmap2.svg)

Let's retrieve the best models:

```julia:ex16
xgb = fitted_params(mtm).best_model
@show xgb.subsample
@show xgb.colsample_bytree
```

We could continue with more fine tuning but given how small the dataset is, it doesn't make much sense.
How does it fare on the test set?

```julia:ex17
ŷ = predict_mode(mtm, rows=test)
round(accuracy(ŷ, y[test]), sigdigits=3)
```

