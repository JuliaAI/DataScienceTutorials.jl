using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, describe, select, Not
import StatsBase: countmap, cor, var
using PrettyPrinting

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)

r3(x) = round(x, sigdigits=3)
r3(pi)

describe(smarket, :mean, :std, :eltype)

y = smarket.Direction
X = select(smarket, Not(:Direction));

cm = X |> Matrix |> cor
round.(cm, sigdigits=1)

using Plots

plot(X.Volume, size=(800,600), linewidth=2, legend=false)
xlabel!("Tick number")
ylabel!("Volume")

y = coerce(y, OrderedFactor)
classes(y[1])

cm = countmap(y)
categories, vals = collect(keys(cm)), collect(values(cm))
Plots.bar(categories, vals, title="Bar Chart Example", legend=false)
ylabel!("Number of occurrences")

LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
classif = machine(LogisticClassifier(), X2, y)

fit!(classif)
ŷ = MLJ.predict(classif, X2)
ŷ[1:3]

cross_entropy(ŷ, y) |> mean |> r3

ŷ = predict_mode(classif, X2)
misclassification_rate(ŷ, y) |> r3

cm = confusion_matrix(ŷ, y)

@show false_positive(cm)
@show accuracy(ŷ, y)  |> r3
@show accuracy(cm)    |> r3  # same thing
@show positive_predictive_value(ŷ, y) |> r3   # a.k.a. precision
@show recall(ŷ, y)    |> r3
@show f1score(ŷ, y)   |> r3

train = 1:findlast(X.Year .< 2005)
test = last(train)+1:length(y);

fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)
accuracy(ŷ, y[test]) |> r3

X3 = select(X2, [:Lag1, :Lag2])
classif = machine(LogisticClassifier(), X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)
accuracy(ŷ, y[test]) |> r3

Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
ŷ = MLJ.predict(classif, Xnew)
ŷ |> pprint

mode.(ŷ)

BayesianLDA = @load BayesianLDA pkg=MultivariateStats

classif = machine(BayesianLDA(), X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3

LDA = @load LDA pkg=MultivariateStats
using Distances

classif = machine(LDA(dist=CosineDist()), X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3

BayesianQDA = @load BayesianQDA pkg=MLJScikitLearnInterface

classif = machine(BayesianQDA(), X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3

KNNClassifier = @load KNNClassifier

knnc = KNNClassifier(K=1)
classif = machine(knnc, X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)
accuracy(ŷ, y[test]) |> r3

knnc.K = 3
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)
accuracy(ŷ, y[test]) |> r3

caravan  = dataset("ISLR", "Caravan")
size(caravan)

purchase = caravan.Purchase
vals     = unique(purchase)

nl1 = sum(purchase .== vals[1])
nl2 = sum(purchase .== vals[2])
println("#$(vals[1]) ", nl1)
println("#$(vals[2]) ", nl2)

cm = countmap(purchase)
categories, vals = collect(keys(cm)), collect(values(cm))
bar(categories, vals, title="Bar Chart Example", legend=false)
ylabel!("Number of occurrences")

y, X = unpack(caravan, ==(:Purchase))

mstd = machine(Standardizer(), X)
fit!(mstd)
Xs = MLJ.transform(mstd, X)

var(Xs[:,1]) |> r3

test = 1:1000
train = last(test)+1:nrows(Xs);

classif = machine(KNNClassifier(K=3), Xs, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3

mean(y[test] .!= "No") |> r3

classif = machine(LogisticClassifier(), Xs, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)

accuracy(ŷ, y[test]) |> r3

ŷ = MLJ.predict(classif, rows=test)

auc(ŷ, y[test])

fprs, tprs, thresholds = roc_curve(ŷ, y[test])

plot(fprs, tprs, linewidth=2, size=(800,600))
xlabel!("False Positive Rate")
ylabel!("True Positive Rate")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
