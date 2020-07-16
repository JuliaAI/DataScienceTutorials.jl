# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

#Relevant packages
using Revise, DataFrames, CSV, LinearAlgebra, Dates, Statistics, MLJ, MLJBase, MLJModels, MLJLinearModels, Plots, Flux
using UrlDownload, MLBase, StatsBase# , ROC, EvalCurves, ==> problem with these last two packages
using Flux:outdims, activations, @epochs, throttle
using Flux.Data

data = urldownload("https://storage.googleapis.com/download.tensorflow.org/data/creditcard.csv")
data = DataFrame(data)

schema(data)

select!(data, Not(:Time))

describe(data)

data[!,:Amount] = log.(data[!,:Amount] .+ 1e-6)

y, X = unpack(data, ==(:Class), col -> true)

train, test = partition(eachindex(y), 0.8, shuffle=true, rng=111)

Xtrain = selectrows(X, train)
Xtest = selectrows(X, test)
ytrain = selectrows(y, train)
ytest = selectrows(y, test)

ytrain_cat = categorical(selectrows(y, train))
ytest_cat = categorical(selectrows(y, test))

stand_model = Standardizer()
std_m_fit = fit!(machine(stand_model, Xtrain))
Xtrain_std = MLJModels.transform(std_m_fit, Xtrain)
Xtest_std = MLJModels.transform(std_m_fit, Xtest)

@load LogisticClassifier pkg=MLJLinearModels

model_logit = LogisticClassifier(lambda=1.0)
m_logit = machine(model_logit, Xtrain, ytrain_cat)
fit!(m_logit)

yhat_logit_p = MLJBase.predict(m_logit, Xtest)
yhat_logit = categorical(mode.(yhat_logit_p))

# How does this model perform?
@show confusion_matrix(yhat_logit, ytest_cat)
@show misclassification_rate(yhat_logit, ytest_cat)

#CSV.write("yhat_logit.csv", yhat_logit)
#CSV.write("yhat_logit_p.csv", yhat_logit_p)

model_logit = @load LogisticClassifier pkg=MLJLinearModels
r = range(model_logit, :lambda, lower=1e-6, upper=100, scale=:log)

self_tuning_logit_model = TunedModel(model=model_logit,
                                                  resampling = CV(nfolds=3),
                                                  tuning = Grid(resolution=10),
                                                  range = r,
                                                  measure = cross_entropy)

self_tuning_logit = machine(self_tuning_logit_model, Xtrain, ytrain_cat)
fit!(self_tuning_logit)

yhat_logit_tuned_p = MLJBase.predict(self_tuning_logit, Xtest)
yhat_logit_tuned = categorical(mode.(yhat_logit_tuned_p))

@show misclassification_rate(yhat_logit_tuned, ytest_cat)

@load SVC

model_svm = @pipeline Std_SVC(std_model = Standardizer(),
                                      svc = SVC())

svc = machine(model_svm, Xtrain, ytrain_cat)

fit!(svc)

yhat_svm = MLJBase.predict(svc, Xtest_std)
#0.00163
@show confusion_matrix(yhat_svm, ytest_cat)
@show misclassification_rate(yhat_svm, ytest_cat)

#@load SVC #does this command need to be repeated?

model_svm = @pipeline Std_SVC(std_model = Standardizer(),
                              svc = SVC())

r = range(model_svm, :(svc.cost), lower=0.0, upper=2.5, scale=:linear)
iterator(r,6)

self_tuning_svm_model = TunedModel(model=model_svm,
                                   resampling = CV(nfolds=3),
                                   tuning = Grid(resolution=6),
                                   range = r,
                                   measure = MLJ.precision)

self_tuning_svm = machine(self_tuning_svm_model, Xtrain, ytrain_cat)

fit!(self_tuning_svm)

@show fitted_params(self_tuning_svm).best_model
@show report(self_tuning_svm)

yhat_svm_tuned = MLJBase.predict(self_tuning_svm, Xtest_std)

@show misclassification_rate(yhat_svm_tuned, ytest_cat)
@show confusion_matrix(yhat_svm_tuned, ytest_cat)

#CSV.write("yhat_svm_tuned.csv", yhat_svm_tuned)

#oversample fraudulent cases (since data so imbalanced)
X_train_oversampled = vcat(X_train,repeat(data_fraud[1:Int(nrow(data_fraud)/2),1:29], 100))
y_train_oversampled = vcat(y_train,repeat(data_fraud[1:Int(nrow(data_fraud)/2),30], 100))

stand_model = Standardizer()
X_train_oversampled_std = MLJModels.transform(fit!(machine(stand_model, X_train_oversampled)), X_train_oversampled)

data1 = DataLoader(Array(X_train_oversampled_std)', y_train_oversampled, batchsize=2048, shuffle=true)

n_inputs = ncol(X_train_oversampled)
n_outputs = 1
n_hidden1 = 16

m = Chain(
          Dense(n_inputs, n_hidden1, relu),
          Dropout(0.1),
          Dense(n_hidden1, n_outputs, σ)
          )

loss(x, y) = Flux.tversky_loss(m(x), y, β=0.9) #tversky loss uses precision and recall, slower calc than crossentropy

ps = Flux.params(m)

opt = Descent()

@epochs 50 Flux.train!(loss, ps, data1, opt)

yhat_nn_p = vec(m(Array(X_test_std)'))
yhat_nn = categorical(Int.(yhat_nn_p .<= 0.5))

cm_nn = confusion_matrix(yhat_nn, y_test)
misclassification_rate(yhat_nn, y_test)

CSV.write("yhat_nn.csv", yhat_nn)

#%%md
*OOS results*
#%%
#if needed can reload from here
yhat_logit_tuned = CSV.read("yhat_logit_tuned.csv")
yhat_svm_tuned = CSV.read("yhat_svm_tuned.csv")
yhat_nn = CSV.read("yhat_nn.csv")

#%%md
Misclassification rate
#%%
misclassification_rate(yhat_logit_tuned, y_test)
misclassification_rate(yhat_svm_tuned, y_test)
misclassification_rate(yhat_nn, y_test)

#%%md
Confusion matrix
#%%
cm_logit = confusion_matrix(yhat_logit_tuned, y_test)
cm_svm = confusion_matrix(yhat_svm_tuned , y_test)
cm_nn = confusion_matrix(yhat_nn, y_test)

#%%md
ROC curves
#%%
#Due to different data output structure had to use different packages for ROC curves
plot(roc_curve(yhat_logit_tuned_p, y_test))

plot(ROC.roc(yhat_nn_p, y_test, 1))

#how to plot this??
MLBase.roc(y_test_int, yhat_nn_p)

#%%md
Precision-Recall curve
#%%
plot(prcurve(pdf.(yhat_logit_tuned_p,1), y_test_int))
plot(prcurve(yhat_nn_p, y_test_int))

#END

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

