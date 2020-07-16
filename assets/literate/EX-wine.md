<!--This file was generated, do not modify it.-->
## Initial data processing

In this example, we consider the [UCI "wine" dataset](https://archive.ics.uci.edu/ml/datasets/wine)

> These data are the results of a chemical analysis of wines grown in the same region in Italy but derived from three different cultivars. The analysis determined the quantities of 13 constituents found in each of the three types of wines.

### Getting the data
Let's download the data thanks to the [HTTP.jl](HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data")) package and load it into a DataFrame via the [CSV.jl](https://github.com/JuliaData/CSV.jl) package:

```julia:ex1
using HTTP, CSV, MLJ, StatsBase, PyPlot
req = HTTP.get("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data")
data = CSV.read(req.body,
                header=["Class", "Alcool", "Malic acid",
                        "Ash", "Alcalinity of ash", "Magnesium",
                        "Total phenols", "Flavanoids",
                        "Nonflavanoid phenols", "Proanthcyanins",
                        "Color intensity", "Hue",
                        "OD280/OD315 of diluted wines", "Proline"])
# the target is the Class column, everything else is a feature
y, X = unpack(data, ==(:Class), colname->true);
```

### Setting the scientific type

Let's explore the scientific type attributed by default to the target and the features

```julia:ex2
scitype(y)
```

this should be changed as it should be considered as an ordered factor

```julia:ex3
yc = coerce(y, OrderedFactor);
```

Let's now consider the features

```julia:ex4
scitype(X)
```

So there are `Continuous` values (encoded as floating point) and `Count` values (integer).
Note also that there are no missing value (otherwise one of the scientific type would have been a `Union{Missing,*}`).
Let's check which column is what:

```julia:ex5
sch = schema(X)
println(rpad(" Name", 28), "| Scitype")
println("-"^45)
for (name, scitype) in zip(sch.names, sch.scitypes)
    println(rpad("$name", 30), scitype)
end
```

The two variable that are encoded as `Count` can  probably be re-interpreted; let's have a look at the `Proline` one to see what it looks like

```julia:ex6
X[1:5, :Proline]
```

It can likely be interpreted as a Continuous as well (it would be better to know precisely what it is but for now let's just go with the hunch).
We'll do the same with `:Magnesium`:

```julia:ex7
Xc = coerce(X, :Proline=>Continuous, :Magnesium=>Continuous);
```

Finally, let's have a quick look at the mean and standard deviation of each feature to get a feel for their amplitude:

```julia:ex8
describe(Xc, :mean, :std)
```

Right so it varies a fair bit which would invite to standardise the data.

**Note**: to complete such a first step, one could explore histograms of the various features for instance, check that there is enough variation among the continuous features and that there does not seem to be problems in the encoding, we cut this out to shorten the tutorial. We could also have checked that the data was balanced.

## Getting a baseline

It's a multiclass classification problem with continuous inputs so a sensible start is  to test two very simple classifiers to get a baseline.
We'll train two simple pipelines:
- a Standardizer + KNN classifier and
- a Standardizer + Multinomial classifier (logistic regression).

```julia:ex9
@load KNNClassifier pkg="NearestNeighbors"
@load MultinomialClassifier pkg="MLJLinearModels";

@pipeline KnnPipe(std=Standardizer(), clf=KNNClassifier()) is_probabilistic=true
@pipeline MnPipe(std=Standardizer(), clf=MultinomialClassifier()) is_probabilistic=true
```

We can now fit this on a train split of the data setting aside 20% of the data for eventual testing.

```julia:ex10
train, test = partition(eachindex(yc), 0.8, shuffle=true, rng=111)
Xtrain = selectrows(Xc, train)
Xtest = selectrows(Xc, test)
ytrain = selectrows(yc, train)
ytest = selectrows(yc, test);
```

Let's now wrap an instance of these models with data (all hyperparameters are set to default here):

```julia:ex11
knn = machine(KnnPipe(), Xtrain, ytrain)
multi = machine(MnPipe(), Xtrain, ytrain)
```

Let's train a KNNClassifier with default hyperparameters and get a baseline misclassification rate using 90% of the training data to train the model and the remaining 10% to evaluate it:

```julia:ex12
opts = (resampling=Holdout(fraction_train=0.9), measure=cross_entropy)
res = evaluate!(knn; opts...)
round(res.measurement[1], sigdigits=3)
```

Now we do the same with a MultinomialClassifier

```julia:ex13
res = evaluate!(multi; opts...)
round(res.measurement[1], sigdigits=3)
```

Both methods seem to offer comparable levels of performance.
Let's check the misclassification over the full training set:

```julia:ex14
mcr_k = misclassification_rate(predict_mode(knn, Xtrain), ytrain)
mcr_m = misclassification_rate(predict_mode(multi, Xtrain), ytrain)
println(rpad("KNN mcr:", 10), round(mcr_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(mcr_m, sigdigits=3))
```

So here we have done no hyperparameter training and already have a misclassification rate below 5%.
Clearly the problem is not very difficult.

## Visualising the classes

One way to get intuition for why the dataset is so easy to classify is to project it onto a 2D space using the PCA and display the two classes to see if they are well separated; we use the arrow-syntax here (if you're on Julia <= 1.2, use the commented-out lines as you won't be able to use the arrow-syntax)

```julia:ex15
# @pipeline PCAPipe(std=Standardizer(), t=PCA(maxoutdim=2))
# pca = machine(PCAPipe(), Xtrain)
# fit!(pca, Xtrain)
# W = transform(pca, Xtrain)

@load PCA

pca = Xc |> Standardizer() |> PCA(maxoutdim=2)
fit!(pca)
W = pca(rows=train);
```

Let's now display this using different colours for the different classes:

```julia:ex16
x1 = W.x1
x2 = W.x2

mask_1 = ytrain .== 1
mask_2 = ytrain .== 2
mask_3 = ytrain .== 3

figure(figsize=(8, 6))
plot(x1[mask_1], x2[mask_1], linestyle="none", marker="o", color="red")
plot(x1[mask_2], x2[mask_2], linestyle="none", marker="o", color="blue")
plot(x1[mask_3], x2[mask_3], linestyle="none", marker="o", color="magenta")

xlabel("PCA dimension 1", fontsize=14)
ylabel("PCA dimension 2", fontsize=14)
legend(["Class 1", "Class 2", "Class 3"], fontsize=12)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/EX-wine-pca.svg") # hide
```

![PCA](/assets/EX-wine-pca.svg)

On that figure it now becomes quite clear why we managed to achieve such high scores with very simple classifiers.
At this point it's a bit pointless to dig much deaper into parameter tuning etc.

As a last step, we can report performances of the models on the test set which we set aside earlier:

```julia:ex17
perf_k = misclassification_rate(predict_mode(knn, Xtest), ytest)
perf_m = misclassification_rate(predict_mode(multi, Xtest), ytest)
println(rpad("KNN mcr:", 10), round(perf_k, sigdigits=3))
println(rpad("MNC mcr:", 10), round(perf_m, sigdigits=3))
```

Pretty good for so little work!

