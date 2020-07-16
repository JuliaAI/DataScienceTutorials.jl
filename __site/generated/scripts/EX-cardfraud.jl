# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# Before running this, please make sure to activate and instantiate the environment# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)# so that you get an environment which matches the one used to generate the tutorials:## ```julia# cd("MLJTutorials") # cd to folder with the *.toml# using Pkg; Pkg.activate("."); Pkg.instantiate()# ```
# Classification of fraudulent/not credit card transactions (imbalanced data)# By Kristian Bjarnason. The original script can be found [here](https://github.com/kbjarnason/credit-card-fraud-classification)# This version implements train, test, val split rather than just train, test.
# ***
# using Pkg; Pkg.add("Revise")# Revise wasn't installed - so installed it, but it triggers update to instantiatd environment (Project.toml,Manifest.toml)
#Relevant packages
using Revise, DataFrames, CSV, LinearAlgebra, Dates, Statistics, MLJ, MLJBase, MLJModels, MLJLinearModels, Plots, Flux
using UrlDownload, MLBase, StatsBase# , ROC, EvalCurves, ==> problem with these last two packages
using Flux:outdims, activations, @epochs, throttle
using Flux.Data

# using AUC # add git@github.com:paulstey/AUC.jl.git
# ***
# ## *Data Preparation*
# Divide the sample into two equal sub-samples. Keep the proportion of frauds the same in each sub-sample (246 frauds in each).# Use one sub-sample to estimate (train) your models and the second one to evaluate the out-of-sample performance of each model.
# ***
# Import data
data = urldownload("https://storage.googleapis.com/download.tensorflow.org/data/creditcard.csv")
data = DataFrame(data)

# Let's inspect the (types of) variables contained in the DataFrame
schema(data)

# The Time column is not relevant to our analysis, we drop it.
select!(data, Not(:Time))

# Let's get a summary of the remaining data.
describe(data)

# Note that the Amount variable spans a wide range of values.# To reduce variation in the data, we take the natural logarithm. Note that some values are 0 and that log(0) will raise an error. We add 1e-6 so no values are 0 prior to being log transformed.# We transform in place using '!'
data[!,:Amount] = log.(data[!,:Amount] .+ 1e-6)

# ***
# Let's unpack the dataframe and create separate frames for our target variable and features.
y, X = unpack(data, ==(:Class), col -> true)

# And partition between training and test observations
train, test = partition(eachindex(y), 0.8, shuffle=true, rng=111)

# Important: train and test are one dimensional arrays and respectively contain the row indices of the train and test sets' observations
# Setup train and test arrays/vectors
Xtrain = selectrows(X, train)
Xtest = selectrows(X, test)
ytrain = selectrows(y, train)
ytest = selectrows(y, test)

# Let's also create categorical versions of the target variable, for use in the LogisticClassifier
ytrain_cat = categorical(selectrows(y, train))
ytest_cat = categorical(selectrows(y, test))

# Create standardised features for SVM and NN
stand_model = Standardizer()
std_m_fit = fit!(machine(stand_model, Xtrain))
Xtrain_std = MLJModels.transform(std_m_fit, Xtrain)
Xtest_std = MLJModels.transform(std_m_fit, Xtest)

# ***
# ##Estimation of models##
# Estimation of three different models:# 1. logit# 2. support vector machines# 3. neural network.
# ### Logit
# **Initial logit classification with lambda = 1.0**
@load LogisticClassifier pkg=MLJLinearModels

model_logit = LogisticClassifier(lambda=1.0)
m_logit = machine(model_logit, Xtrain, ytrain_cat)
fit!(m_logit)

# **Predictions**
# The prediction from the LogisticClassifier is a probabilistic output, i.e. for each observation in the sample it attaches a probability to each of the possible values of the target.# To recover a deterministic output, we take the mode of the distribution.
yhat_logit_p = MLJBase.predict(m_logit, Xtest)
yhat_logit = categorical(mode.(yhat_logit_p))

# How does this model perform?
@show confusion_matrix(yhat_logit, ytest_cat)
@show misclassification_rate(yhat_logit, ytest_cat)

# (Looks like it's not too bad)# Let' see if we can do even better by doing a little tuning.
#CSV.write("yhat_logit.csv", yhat_logit)
#CSV.write("yhat_logit_p.csv", yhat_logit_p)

# ***
# ### Tuned logit
# Still LogisticClassifier but implementing hyperparameter tuning.
model_logit = @load LogisticClassifier pkg=MLJLinearModels
r = range(model_logit, :lambda, lower=1e-6, upper=100, scale=:log)

# The tuning strategy is specified below; note the use of a probabilistic measure (cross_entropy).
self_tuning_logit_model = TunedModel(model=model_logit,
                                                  resampling = CV(nfolds=3),
                                                  tuning = Grid(resolution=10),
                                                  range = r,
                                                  measure = cross_entropy)

self_tuning_logit = machine(self_tuning_logit_model, Xtrain, ytrain_cat)
fit!(self_tuning_logit)

# Predictions
yhat_logit_tuned_p = MLJBase.predict(self_tuning_logit, Xtest)
yhat_logit_tuned = categorical(mode.(yhat_logit_tuned_p))

# Let's take a look at the misclassification_rate. It is, surprisingly, slightly higher than the one calculated for the non tuned model.
@show misclassification_rate(yhat_logit_tuned, ytest_cat)

# ### Support Vector Machine
# ***
# Initial SVM classification with cost = 1.0
@load SVC

# To fit the SVM, we declare a pipeline which comprises both a standardizer and the model
model_svm = @pipeline Std_SVC(std_model = Standardizer(),
                                      svc = SVC())

svc = machine(model_svm, Xtrain, ytrain_cat)

fit!(svc)

yhat_svm = MLJBase.predict(svc, Xtest_std)
#0.00163
@show confusion_matrix(yhat_svm, ytest_cat)
@show misclassification_rate(yhat_svm, ytest_cat)

# CSV.write("yhat_svm.csv", yhat_svm)
# ***
# Tuned SVM
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

# ### Neural Network
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

# loss(x, y) = Flux.crossentropy(m(x), y)
ps = Flux.params(m)

# opt = ADAM()
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

# plot(ROC.roc(pdf.(yhat_logit_tuned_p), y_test, 1)))
plot(ROC.roc(yhat_nn_p, y_test, 1))

# don't have score vectors for SVM# plot(roc_curve(yhat_svm_p,y_test))# plot(roc_curve(yhat_nn_p,y_test))
#how to plot this??
MLBase.roc(y_test_int, yhat_nn_p)

#%%md
Precision-Recall curve
#%%
plot(prcurve(pdf.(yhat_logit_tuned_p,1), y_test_int))
plot(prcurve(yhat_nn_p, y_test_int))

# don't have score vectors for SVM# plot(prcurve(pdf.(yhat_svm_p,1), y_test_int))
#END

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

