# This file was generated, do not modify it.

using MLJ, RDatasets, ScientificTypes,
      DataFrames, Statistics, StatsBase
using PrettyPrinting

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)

r3 = x -> round(x, sigdigits=3)
r3(pi)

describe(smarket, :mean, :std, :eltype)

y = smarket.Direction
X = select(smarket, Not(:Direction));

cm = X |> Matrix |> cor
round.(cm, sigdigits=1)

using PyPlot
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/ISL-lab-4-volume.svg") # hide

y = coerce(y, OrderedFactor)
classes(y[1])

figure(figsize=(8,6))
cm = countmap(y)
bar([1, 2], [cm["Down"], cm["Up"]])
xticks([1, 2], ["Down", "Up"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig("assets/literate/ISL-lab-4-bal.svg") # hide

@load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
clf = machine(LogisticClassifier(), X2, y)

fit!(clf)
ŷ = predict(clf, X2)
ŷ[1:3]

cross_entropy(ŷ, y) |> mean |> r3

ŷ = predict_mode(clf, X2)
misclassification_rate(ŷ, y) |> r3

cm = confusion_matrix(ŷ, y)

@show fp(cm)                 # false positives
@show accuracy(ŷ, y)  |> r3
@show accuracy(cm)    |> r3  # same thing
@show precision(ŷ, y) |> r3
@show recall(ŷ, y)    |> r3
@show f1score(ŷ, y)   |> r3

train = 1:findlast(X.Year .< 2005)
test = last(train)+1:length(y);

fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3

X3 = select(X2, [:Lag1, :Lag2])
clf = machine(LogisticClassifier(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3

Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
ŷ = predict(clf, Xnew)
ŷ |> pprint

mode.(ŷ)

@load BayesianLDA pkg=MultivariateStats

clf = machine(BayesianLDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3

@load LDA pkg=MultivariateStats
using Distances

clf = machine(LDA(dist=CosineDist()), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3

@load BayesianQDA pkg=ScikitLearn

clf = machine(BayesianQDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3

@load KNNClassifier pkg=NearestNeighbors

knnc = KNNClassifier(K=1)
clf = machine(knnc, X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3

knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3

caravan  = dataset("ISLR", "Caravan")
size(caravan)

purchase = caravan.Purchase
vals     = unique(purchase)

nl1 = sum(purchase .== vals[1])
nl2 = sum(purchase .== vals[2])
println("#$(vals[1]) ", nl1)
println("#$(vals[2]) ", nl2)

figure(figsize=(8,6))
cm = countmap(purchase)
bar([1, 2], [cm["No"], cm["Yes"]])
xticks([1, 2], ["No", "Yes"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig("assets/literate/ISL-lab-4-bal2.svg") # hide

y, X = unpack(caravan, ==(:Purchase), col->true)

std = machine(Standardizer(), X)
fit!(std)
Xs = transform(std, X)

var(Xs[:,1]) |> r3

test = 1:1000
train = last(test)+1:nrows(Xs);

clf = machine(KNNClassifier(K=3), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3

mean(y[test] .!= "No") |> r3

clf = machine(LogisticClassifier(), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

accuracy(ŷ, y[test]) |> r3

ŷ = predict(clf, rows=test)

auc(ŷ, y[test])

fprs, tprs, thresholds = roc(ŷ, y[test])

figure(figsize=(8,6))
plot(fprs, tprs)

xlabel("False Positive Rate", fontsize=14)
ylabel("True Positive Rate", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig("assets/literate/ISL-lab-4-roc.svg") # hide

