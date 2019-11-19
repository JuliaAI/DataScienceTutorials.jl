# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Stock market data## Let's load the usual packages and the data
using MLJ, RDatasets, ScientificTypes,
      DataFrames, Statistics, StatsBase

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)

# Let's get a description too
describe(smarket, :mean, :std, :eltype)

# The target variable is `:Direction`:
y = smarket.Direction
X = select(smarket, Not(:Direction));

# We can compute all the pairwise correlations; we use `Matrix` so that the dataframe entries are considered as one matrix of numbers (otherwise `cor` won't work):
cm = X |> Matrix |> cor
round.(cm, sigdigits=1)

# Let's see what the `:Volume` feature looks like:
using PyPlot
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)



# ![volume](/assets/ISL-volume.svg)
# ### Logistic Regression## We will now try to train models; the target `:Direction` has two classes: `Up` and `Down`; it needs to be interpreted as a Multiclass object first:
yc = coerce(y, Multiclass)
unique(yc)

# Let's now try fitting a simple logistic classifier (aka logistic regression) not using `:Year` and `:Today`:
@load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
clf = machine(LogisticClassifier(), X2, y)

# Let's fit it to the data and try to reproduce the output:
fit!(clf)
ŷ = predict(clf, X2)
cross_entropy(ŷ, y) |> mean

# Note that here the `ŷ` are _scores_; in order to recover the class, we could use the mode and compare the misclassification rate:
ŷ = predict_mode(clf, X2)
misclassification_rate(ŷ, y)

# Well that's not fantastic...## Let's visualise how we're doing building a confusion matrix manually,# first is predicted, second is truth:
TN = down_down = sum(ŷ .== y .== "Down")
FN = down_up = sum(ŷ .!= y .== "Up")
FP = up_down = sum(ŷ .!= y .== "Down")
TP = up_up = sum(ŷ .== y .== "Up")

conf_mat = [down_down down_up; up_down up_up]

# We can then compute the accuracy or precision easily for instance:
acc = (TN + TP) / length(y)
prec = TP /  (TP + FP)
rec  = TP / (TP + FN)
@show round(acc, sigdigits=3)
@show round(prec, sigdigits=3)
@show round(rec, sigdigits=3)

# Let's now train on the data before 2005 and use it to predict on the rest.# Let's find the row indices for which the condition holds
train = 1:findlast(X.Year .< 2005);
test = last(train)+1:length(y)

# We can now just re-fit the machine that we've already defined just on those rows and predict on the test:
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mcr = misclassification_rate(ŷ, y[test])
accuracy = 1 - mcr

# Let's retrain a machine using only `:Lag1` and `:Lag2`:
X3 = select(X2, [:Lag1, :Lag2])
clf = machine(LogisticClassifier(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mean(ŷ .== y[test])

# Interesting... it has higher accuracy than the model with more features! This could be investigated further by increasing the regularisation parameter but we'll leave it aside for  now.## We can use a trained machine to predict on new data:
Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
@show ŷ = predict(clf, Xnew)

# Note: when specifying data, we used a simple `NamedTuple`; we could also have defined a dataframe or any other compatible tabular container.# Note also that we retrieved the raw predictions here i.e.: a score for each class; we could have used `predict_mode` or indeed
mode.(ŷ)

# ### LDA## Let's do a similar thing but with a LDA model this time:
@load BayesianLDA pkg=MultivariateStats

clf = machine(BayesianLDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

# Note: `BayesianLDA` is LDA using a multivariate normal model for each class with a default prior inferred from the proportions for each class in the training data.# You can also use the bare `LDA` model which does not make these assumptions and allows using a different metric in the transformed space, see the docs for details.
@load LDA pkg=MultivariateStats
using Distances

clf = machine(LDA(dist=CosineDist()), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

# ### QDA## Bayesian QDA is available via ScikitLearn:
@load BayesianQDA pkg=ScikitLearn

# Using it is done in much the same way as before:
clf = machine(BayesianQDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

# ### KNN## Multiple packages offer KNN, we go via NearestNeighbors:
@load KNNClassifier pkg=NearestNeighbors

knnc = KNNClassifier(K=1)
clf = machine(knnc, X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])

# Let's try with three neighbors
knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])

# ## Caravan insurance data## The caravan dataset is part of ISLR as well:
caravan  = dataset("ISLR", "Caravan")
@show size(caravan)

# The target variable is `Purchase`, effectively  a categorical
purchase = caravan.Purchase
vals     = unique(purchase)

# Let's see how many of each we have
nl1 = sum(purchase .== vals[1])
nl2 = sum(purchase .== vals[2])
println("#$(vals[1]) ", nl1)
println("#$(vals[2]) ", nl2)

# that's quite unbalanced.## Apart from the target, all other variables are numbers; we can standardize the data:
y, X = unpack(caravan, ==(:Purchase), col->true)

std = machine(Standardizer(), X)
fit!(std)
Xs = transform(std, X)

var(Xs[:,1])

# **Note**: in MLJ, it is recommended to work with pipelines / networks when possible and not do "step-by-step" transformation and fitting of the data as this is more error prone. We do it here to stick to the ISL tutorial.## We split the data in the first 1000 rows for testing and the rest for training:
test = 1:1000
train = last(test)+1:nrows(Xs);

# Let's now fit a KNN model and check the misclassification rate
clf = machine(KNNClassifier(K=3), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])

# that looks good but recall the problem is very unbalanced
mean(y[test] .!= "No")

# Let's fit a logistic classifier to this problem
clf = machine(LogisticClassifier(), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

