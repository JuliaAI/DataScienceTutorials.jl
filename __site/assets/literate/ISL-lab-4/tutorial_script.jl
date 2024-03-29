# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/ISL-lab-4/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, describe, select, Not
import StatsBase: countmap, cor, var
MLJ.color_off() # hide
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

using PyPlot
ioff() # hide
figure(figsize=(8,6))
plot(X.Volume)
xlabel("Tick number", fontsize=14)
ylabel("Volume", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "ISL-lab-4-volume.svg")) # hide

y = coerce(y, OrderedFactor)
classes(y[1])

figure(figsize=(8,6))
cm = countmap(y)
PyPlot.bar([1, 2], [cm["Down"], cm["Up"]])
xticks([1, 2], ["Down", "Up"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-4-bal.svg")) # hide

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
@show precision(ŷ, y) |> r3
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

BayesianQDA = @load BayesianQDA pkg=ScikitLearn

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

figure(figsize=(8,6))
cm = countmap(purchase)
PyPlot.bar([1, 2], [cm["No"], cm["Yes"]])
xticks([1, 2], ["No", "Yes"], fontsize=12)
yticks(fontsize=12)
ylabel("Number of occurences", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-4-bal2.svg")) # hide

y, X = unpack(caravan, ==(:Purchase), col->true)

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

fprs, tprs, thresholds = roc(ŷ, y[test])

figure(figsize=(8,6))
plot(fprs, tprs)

xlabel("False Positive Rate", fontsize=14)
ylabel("True Positive Rate", fontsize=14)
xticks(fontsize=12)
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "ISL-lab-4-roc.svg")) # hide

PyPlot.close_figs() # hide

