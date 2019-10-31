<!--This file was generated, do not modify it.-->
## Stock market data

Let's load the usual packages and the data

```julia:ex1
using MLJ, RDatasets, ScientificTypes,
      DataFrames, Statistics, StatsBase

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)
```

Let's get a description too

```julia:ex2
describe(smarket, :mean, :std, :eltype)
```

The target variable is `:Direction`:

```julia:ex3
y = smarket.Direction
X = select(smarket, Not(:Direction));
```

We can compute all the pairwise correlations; we use `Matrix` so that the dataframe entries are considered as one matrix of numbers (otherwise `cor` won't work):

```julia:ex4
cm = X |> Matrix |> cor
round.(cm, sigdigits=1)
```

Let's see what the `:Volume` feature looks like:

```julia:ex5
using PyPlot
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/ISL-volume.svg") # hide
```

![volume](/assets/ISL-volume.svg)

### Logistic Regression

We will now try to train models; the target `:Direction` has two classes: `Up` and `Down`; it needs to be interpreted as a Multiclass object first:

```julia:ex6
yc = coerce(y, Multiclass)
unique(yc)
```

Let's now try fitting a simple logistic classifier (aka logistic regression) not using `:Year` and `:Today`:

```julia:ex7
@load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
clf = machine(LogisticClassifier(), X2, y)
```

Let's fit it to the data and try to reproduce the output:

```julia:ex8
fit!(clf)
ŷ = predict(clf, X2)
cross_entropy(ŷ, y) |> mean
```

Note that here the `ŷ` are _scores_; in order to recover the class, we could use the mode and compare the misclassification rate:

```julia:ex9
ŷ = predict_mode(clf, X2)
misclassification_rate(ŷ, y)
```

Well that's not fantastic...

Let's visualise how we're doing building a confusion matrix manually,
first is predicted, second is truth:

```julia:ex10
TN = down_down = sum(ŷ .== y .== "Down")
FN = down_up = sum(ŷ .!= y .== "Up")
FP = up_down = sum(ŷ .!= y .== "Down")
TP = up_up = sum(ŷ .== y .== "Up")

conf_mat = [down_down down_up; up_down up_up]
```

We can then compute the accuracy or precision easily for instance:

```julia:ex11
acc = (TN + TP) / length(y)
prec = TP /  (TP + FP)
rec  = TP / (TP + FN)
@show round(acc, sigdigits=3)
@show round(prec, sigdigits=3)
@show round(rec, sigdigits=3)
```

Let's now train on the data before 2005 and use it to predict on the rest.

### LDA

### QDA

_QDA is not yet supported_

### KNN

## Caravan insurance data

