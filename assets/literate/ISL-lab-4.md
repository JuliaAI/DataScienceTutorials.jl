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

We can compute all the pairwise correlations; we use `Matrix` so that the dataframe entries are considered as one matrix of numbers with the same type (otherwise `cor` won't work):

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
ŷ[1:3]
```

Note that here the `ŷ` are _scores_.
We can recover the average cross-entropy loss:

```julia:ex9
cross_entropy(ŷ, y) |> mean
```

in order to recover the class, we could use the mode and compare the misclassification rate:

```julia:ex10
ŷ = predict_mode(clf, X2)
misclassification_rate(ŷ, y)
```

Well that's not fantastic...

Let's visualise how we're doing building a confusion matrix manually,
first is predicted, second is truth:

```julia:ex11
TN = down_down = sum(ŷ .== y .== "Down")
FN = down_up = sum(ŷ .!= y .== "Up")
FP = up_down = sum(ŷ .!= y .== "Down")
TP = up_up = sum(ŷ .== y .== "Up")

conf_mat = [down_down down_up; up_down up_up]
```

We can then compute the accuracy or precision easily for instance:

```julia:ex12
acc = (TN + TP) / length(y)
prec = TP /  (TP + FP)
rec  = TP / (TP + FN)
@show round(acc, sigdigits=3)
@show round(prec, sigdigits=3)
@show round(rec, sigdigits=3)
```

Let's now train on the data before 2005 and use it to predict on the rest.
Let's find the row indices for which the condition holds

```julia:ex13
train = 1:findlast(X.Year .< 2005);
test = last(train)+1:length(y)
```

We can now just re-fit the machine that we've already defined just on those rows and predict on the test:

```julia:ex14
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mcr = misclassification_rate(ŷ, y[test])
accuracy = 1 - mcr
```

Let's retrain a machine using only `:Lag1` and `:Lag2`:

```julia:ex15
X3 = select(X2, [:Lag1, :Lag2])
clf = machine(LogisticClassifier(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mean(ŷ .== y[test])
```

Interesting... it has higher accuracy than the model with more features! This could be investigated further by increasing the regularisation parameter but we'll leave it aside for  now.

We can use a trained machine to predict on new data:

```julia:ex16
Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
@show ŷ = predict(clf, Xnew)
```

Note: when specifying data, we used a simple `NamedTuple`; we could also have defined a dataframe or any other compatible tabular container.
Note also that we retrieved the raw predictions here i.e.: a score for each class; we could have used `predict_mode` or indeed

```julia:ex17
mode.(ŷ)
```

### LDA

Let's do a similar thing but with a LDA model this time:

```julia:ex18
@load BayesianLDA pkg=MultivariateStats

clf = machine(BayesianLDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])
```

Note: `BayesianLDA` is LDA using a multivariate normal model for each class with a default prior inferred from the proportions for each class in the training data.
You can also use the bare `LDA` model which does not make these assumptions and allows using a different metric in the transformed space, see the docs for details.

```julia:ex19
@load LDA pkg=MultivariateStats
using Distances

clf = machine(LDA(dist=CosineDist()), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])
```

### QDA

Bayesian QDA is available via ScikitLearn:

```julia:ex20
@load BayesianQDA pkg=ScikitLearn
```

Using it is done in much the same way as before:

```julia:ex21
clf = machine(BayesianQDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])
```

### KNN

Multiple packages offer KNN, we go via NearestNeighbors:

```julia:ex22
@load KNNClassifier pkg=NearestNeighbors

knnc = KNNClassifier(K=1)
clf = machine(knnc, X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])
```

Let's try with three neighbors

```julia:ex23
knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])
```

## Caravan insurance data

The caravan dataset is part of ISLR as well:

```julia:ex24
caravan  = dataset("ISLR", "Caravan")
@show size(caravan)
```

The target variable is `Purchase`, effectively  a categorical

```julia:ex25
purchase = caravan.Purchase
vals     = unique(purchase)
```

Let's see how many of each we have

```julia:ex26
nl1 = sum(purchase .== vals[1])
nl2 = sum(purchase .== vals[2])
println("#$(vals[1]) ", nl1)
println("#$(vals[2]) ", nl2)
```

that's quite unbalanced.

Apart from the target, all other variables are numbers; we can standardize the data:

```julia:ex27
y, X = unpack(caravan, ==(:Purchase), col->true)

std = machine(Standardizer(), X)
fit!(std)
Xs = transform(std, X)

var(Xs[:,1])
```

**Note**: in MLJ, it is recommended to work with pipelines / networks when possible and not do "step-by-step" transformation and fitting of the data as this is more error prone. We do it here to stick to the ISL tutorial.

We split the data in the first 1000 rows for testing and the rest for training:

```julia:ex28
test = 1:1000
train = last(test)+1:nrows(Xs);
```

Let's now fit a KNN model and check the misclassification rate

```julia:ex29
clf = machine(KNNClassifier(K=3), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])
```

that looks good but recall the problem is very unbalanced

```julia:ex30
mean(y[test] .!= "No")
```

Let's fit a logistic classifier to this problem

```julia:ex31
clf = machine(LogisticClassifier(), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])
```

