<!--This file was generated, do not modify it.-->
## Getting started

```julia:ex1
using MLJ, RDatasets, PrettyPrinting, ScientificTypes

@load DecisionTreeClassifier pkg=DecisionTree

carseats = dataset("ISLR", "Carseats")

first(carseats, 3) |> pretty
```

We encode a new variable `High` based on whether the sales are higher or lower than 8 and add that column to the dataframe:

```julia:ex2
High = ifelse.(carseats.Sales .<= 8, "No", "Yes") |> categorical;
carseats[!, :High] = High;
```

Let's now train a basic decision tree classifier for `High` given the other features after one-hot-encoding the categorical features:

```julia:ex3
X = select(carseats, Not([:Sales, :High]))
y = carseats.High;
```

### Decision Tree Classifier

```julia:ex4
@pipeline HotTreeClf(hot = OneHotEncoder(),
                     tree = DecisionTreeClassifier()) is_probabilistic=true

mdl = HotTreeClf()
mach = machine(mdl, X, y)
fit!(mach);
```

Note that this is trained on the whole data.

```julia:ex5
ypred = predict_mode(mach, X)
misclassification_rate(ypred, y)
```

That's right... it gets it perfectly; this tends to be classic behaviour for a DTC to overfit the data it's trained on.
Let's see if it generalises:

```julia:ex6
train, test = partition(eachindex(y), 0.5, shuffle=true, rng=333)
fit!(mach, rows=train)
ypred = predict_mode(mach, rows=test)
misclassification_rate(ypred, y[test])
```

Not really...

### Tuning a DTC

Let's try to do a bit of tuning

```julia:ex7
r_mpi = range(mdl, :(tree.max_depth), lower=1, upper=10)
r_msl = range(mdl, :(tree.min_samples_leaf), lower=1, upper=50)

tm = TunedModel(model=mdl, ranges=[r_mpi, r_msl], tuning=Grid(resolution=8),
                resampling=CV(nfolds=5, rng=112),
                operation=predict_mode, measure=misclassification_rate)
mtm = machine(tm, X, y)
fit!(mtm, rows=train)

ypred = predict_mode(mtm, rows=test)
misclassification_rate(ypred, y[test])
```

We can inspect the parameters of the best model

```julia:ex8
fitted_params(mtm).best_model.tree
```

### Decision Tree Regressor

```julia:ex9
@load DecisionTreeRegressor pkg=DecisionTree

boston = dataset("MASS", "Boston")

y, X = unpack(boston, ==(:MedV), col -> true)

train, test = partition(eachindex(y), 0.5, shuffle=true, rng=551);

scitype(X)
```

Let's recode the Count as Continuous and then fit a DTR

```julia:ex10
X = coerce(X, autotype(X, rules=(:discrete_to_continuous,)))

dtr_model = DecisionTreeRegressor()
dtr = machine(dtr_model, X, y)

fit!(dtr, rows=train)

ypred = predict(dtr, rows=test)
round(rms(ypred, y[test]), sigdigits=3)
```

Again we can try tuning this a bit, since it's the same idea as before, let's just try to adjust the depth of the tree:

```julia:ex11
r_depth = range(dtr_model, :max_depth, lower=2, upper=20)

tm = TunedModel(model=dtr_model, ranges=[r_depth], tuning=Grid(resolution=10),
                resampling=CV(nfolds=5, rng=1254), measure=rms)
mtm = machine(tm, X, y)

fit!(mtm, rows=train)

ypred = predict(mtm, rows=test)
round(rms(ypred, y[test]), sigdigits=3)
```

## Random Forest

**Note**: the package [`DecisionTree.jl`](https://github.com/bensadeghi/DecisionTree.jl) also has a RandomForest model but it is not yet interfaced with in MLJ.

```julia:ex12
@load RandomForestRegressor pkg=ScikitLearn

rf_mdl = RandomForestRegressor()
rf = machine(rf_mdl, X, y)
fit!(rf, rows=train)

ypred = predict(rf, rows=test)
round(rms(ypred, y[test]), sigdigits=3)
```

## Gradient Boosting Machine

```julia:ex13
@load XGBoostRegressor

xgb_mdl = XGBoostRegressor(num_round=10, max_depth=10)
xgb = machine(xgb_mdl, X, y)
fit!(xgb, rows=train)

ypred = predict(xgb, rows=test)
round(rms(ypred, y[test]), sigdigits=3)
```

Again we could do some tuning for this.

