using Dates, Statistics, LinearAlgebra, Random # standard libraries
using MLJ, Plots, DataFrames, UrlDownload
using CSV # needed for `urldownload` to work
import StatsBase # needed for `countmap`

Plots.scalefontsizes(0.85)

table = urldownload(
"https://storage.googleapis.com/download.tensorflow.org/data/creditcard.csv",
);
data = DataFrame(table)
first(data, 4)

schema(data)

select!(data, Not(:Time));

coerce!(data, :Class => OrderedFactor);

scitype(data.Class)

levels(data.Class) # second element is `positive` class

describe(data)

data[!,:Amount] = log.(data[!,:Amount] .+ 1e-6);
histogram(data.Amount)

reduction = 0.05
frac_train = 0.8*reduction
frac_test = 0.2*reduction

y, X = unpack(data, ==(:Class))
(Xtrain, Xtest, _), (ytrain, ytest, _) =
    partition((X, y), frac_train, frac_test; stratify=y, multi=true, rng=111);

StatsBase.countmap(ytrain)

StatsBase.countmap(ytest)

LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels
model_logit = LogisticClassifier(lambda=1.0)
mach = machine(model_logit, Xtrain, ytrain) |> fit!

yhat_logit = predict_mode(mach, Xtest);
first(yhat_logit, 4)

# How does this model perform?

confusion_matrix(yhat_logit, ytest)

yhat = predict(mach, Xtest);
yhat[1:3]

false_positive_rates, true_positive_rates, thresholds =
    roc_curve(yhat, ytest)
plot(false_positive_rates, true_positive_rates)
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black, label=:none)
xlabel!("false positive rate")
ylabel!("true positive rate")

misclassification_rate(yhat_logit, ytest)

r = range(model_logit, :lambda, lower=1e-6, upper=100, scale=:log)

self_tuning_logit_model = TunedModel(
    model_logit,
    tuning = Grid(resolution=10),
    resampling = CV(nfolds=3),
    range = r,
    measure = misclassification_rate,
)

mach = machine(self_tuning_logit_model, Xtrain, ytrain) |> fit!

yhat_logit_tuned = predict_mode(mach, Xtest);

@show misclassification_rate(yhat_logit_tuned, ytest)

SVC = @load SVC pkg = LIBSVM

model_svm = Standardizer() |>  SVC()
mach = machine(model_svm, Xtrain, ytrain) |> fit!
yhat_svm = predict(mach, Xtest)
confusion_matrix(yhat_svm, ytest)

@show misclassification_rate(yhat_svm, ytest)

r = range(model_svm, :(svc.cost), lower=0.1, upper=3.5, scale=:linear)
self_tuning_svm_model = TunedModel(
    model_svm,
    resampling = CV(nfolds=3),
    tuning = Grid(resolution=6),
    range = r,
    measure = misclassification_rate,
)
mach = machine(self_tuning_svm_model, Xtrain, ytrain) |> fit!

fitted_params(mach).best_model

plot(mach)

yhat_svm_tuned = predict(mach, Xtest)
confusion_matrix(yhat_svm_tuned, ytest)

misclassification_rate(yhat_svm_tuned, ytest)

NeuralNetworkClassifier = @load NeuralNetworkClassifier pkg=MLJFlux

import MLJFlux.@builder
using Flux

builder = @builder Chain(
    Dense(n_in, 16, relu),
    Dropout(0.1; rng=rng),
    Dense(16, n_out),
)

rng = Xoshiro(123)
model = NeuralNetworkClassifier(
    ; builder,
    loss=(yhat, y)->Flux.tversky_loss(yhat, y, β=0.9), # combines precision and recall
    batch_size = round(Int, reduction*2048),
    epochs=50,
    rng,
)

StatsBase.countmap(y)

models("oversampler")

SMOTE = @load SMOTE pkg=Imbalance
balanced_model = BalancedModel(model, oversampler=SMOTE())

model_nn = Standardizer() |> balanced_model

mach = machine(model_nn, Xtrain, ytrain) |> fit!
yhat_nn = predict_mode(mach, Xtest);
confusion_matrix(yhat_nn, ytest)

misclassification_rate(yhat_nn, ytest)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
