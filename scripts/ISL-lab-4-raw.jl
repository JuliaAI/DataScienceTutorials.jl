# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ, RDatasets, ScientificTypes,
      DataFrames, Statistics, StatsBase

smarket = dataset("ISLR", "Smarket")
@show size(smarket)
@show names(smarket)

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



yc = coerce(y, Multiclass)
unique(yc)

@load LogisticClassifier pkg=MLJLinearModels
X2 = select(X, Not([:Year, :Today]))
clf = machine(LogisticClassifier(), X2, y)

fit!(clf)
ŷ = predict(clf, X2)
ŷ[1:3]

cross_entropy(ŷ, y) |> mean

ŷ = predict_mode(clf, X2)
misclassification_rate(ŷ, y)

TN = down_down = sum(ŷ .== y .== "Down")
FN = down_up = sum(ŷ .!= y .== "Up")
FP = up_down = sum(ŷ .!= y .== "Down")
TP = up_up = sum(ŷ .== y .== "Up")

conf_mat = [down_down down_up; up_down up_up]

acc = (TN + TP) / length(y)
prec = TP /  (TP + FP)
rec  = TP / (TP + FN)
@show round(acc, sigdigits=3)
@show round(prec, sigdigits=3)
@show round(rec, sigdigits=3)

train = 1:findlast(X.Year .< 2005);
test = last(train)+1:length(y)

fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mcr = misclassification_rate(ŷ, y[test])
accuracy = 1 - mcr

X3 = select(X2, [:Lag1, :Lag2])
clf = machine(LogisticClassifier(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mean(ŷ .== y[test])

Xnew = (Lag1 = [1.2, 1.5], Lag2 = [1.1, -0.8])
@show ŷ = predict(clf, Xnew)

mode.(ŷ)

@load BayesianLDA pkg=MultivariateStats

clf = machine(BayesianLDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

@load LDA pkg=MultivariateStats
using Distances

clf = machine(LDA(dist=CosineDist()), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

@load BayesianQDA pkg=ScikitLearn

clf = machine(BayesianQDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])

@load KNNClassifier pkg=NearestNeighbors

knnc = KNNClassifier(K=1)
clf = machine(knnc, X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])

knnc.K = 3
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
@show mean(ŷ .== y[test])

caravan  = dataset("ISLR", "Caravan")
@show size(caravan)

purchase = caravan.Purchase
vals     = unique(purchase)

nl1 = sum(purchase .== vals[1])
nl2 = sum(purchase .== vals[2])
println("#$(vals[1]) ", nl1)
println("#$(vals[2]) ", nl2)

y, X = unpack(caravan, ==(:Purchase), col->true)

std = machine(Standardizer(), X)
fit!(std)
Xs = transform(std, X)

var(Xs[:,1])

test = 1:1000
train = last(test)+1:nrows(Xs);

clf = machine(KNNClassifier(K=3), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])

mean(y[test] .!= "No")

clf = machine(LogisticClassifier(), Xs, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

misclassification_rate(ŷ, y[test])

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

