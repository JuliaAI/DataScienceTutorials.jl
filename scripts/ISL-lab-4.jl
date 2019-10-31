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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

