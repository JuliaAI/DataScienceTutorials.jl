# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/end-to-end/creditfraud/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/end-to-end/creditfraud/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# Classification of fraudulent/not credit card transactions (imbalanced data)
# By Kristian Bjarnason. The original script can be found [here](https://github.com/kbjarnason/credit-card-fraud-classification)

# **Editor's note.** To reduce training times, we have reduced the the original number of
# data observations. To re-instate the full dataset (290k observations) change
# `reduction=0.05` to `reduction=1`. The data is highly imbalanced, and this is ignored
# when training some models. Some other changes to Bjarnason's original notebook are noted
# at the end.

using Dates, Statistics, LinearAlgebra, Random # standard libraries
using MLJ, Plots, DataFrames, UrlDownload
using CSV # needed for `urldownload` to work
import StatsBase # needed for `countmap`

# Adjusting fontsize in plotting:

Plots.scalefontsizes(0.85)

# @@dropdown
# ## Data Preparation
# @@
# @@dropdown-content

# Divide the sample into two equal sub-samples. Keep the proportion of frauds the same in
# each sub-sample (246 frauds in each).  Use one sub-sample to estimate (train) your
# models and the second one to evaluate the out-of-sample performance of each model.

# Importing the data:

table = urldownload(
"https://storage.googleapis.com/download.tensorflow.org/data/creditcard.csv",
);
data = DataFrame(table)
first(data, 4)

# Inspecting the scientific types of variables contained in the DataFrame:

schema(data)

# The Time column is not relevant to our analysis, we drop it:

select!(data, Not(:Time));

# And the target variable, `Class`, should not be interpretted by our algorithms as a
# `Count` variable. We'll view it as an *ordered* factor (i.e., binary data with an
# intrinsic `positive` class, corresponding here to `1`, the second in the lexigrahic
# ordering).

coerce!(data, :Class => OrderedFactor);

# We can check by calling `schema` again, or like this:

scitype(data.Class)

levels(data.Class) # second element is `positive` class

# Let's get a summary of the remaining data.

describe(data)

# Note that the `Amount` variable spans a wide range of values.  To reduce variation in
# the data, we take logs. Since some values are `0`, we first add `1e-6` to eavh value.
# We transform in place using '!':

data[!,:Amount] = log.(data[!,:Amount] .+ 1e-6);
histogram(data.Amount)

# \fig{EX-creditfraud-amount.svg}

# Next we unpack the dataframe and creating a separate frame `X` for input features
# (predictors) and vector `y` for the target variable. Because of class imbalance, we make
# the partition stratified, and we also dump some observations, to reduce training
# times. Change the next line to `reduction = 1` to keep all the data:

reduction = 0.05
frac_train = 0.8*reduction
frac_test = 0.2*reduction

y, X = unpack(data, ==(:Class))
(Xtrain, Xtest, _), (ytrain, ytest, _) =
    partition((X, y), frac_train, frac_test; stratify=y, multi=true, rng=111);

StatsBase.countmap(ytrain)

StatsBase.countmap(ytest)

# ‎
# @@
# @@dropdown
# ## Estimation of models
# @@
# @@dropdown-content

# We will estimate of three different models:

# 1. logit
# 2. support vector machines
# 3. neural network.

# @@dropdown
# ### Logit
# @@
# @@dropdown-content

# ‎
# @@
# @@dropdown
# ### Initial logit classification with lambda = 1.0
# @@
# @@dropdown-content

LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels
model_logit = LogisticClassifier(lambda=1.0)
mach = machine(model_logit, Xtrain, ytrain) |> fit!

# #### Predictions

# `LogisticClassifier` is a probabilistic predictor, i.e. for each observation in the
# sample it attaches a probability to each of the possible values of the target.  To
# recover a deterministic output, we use `predict_mode` instead of `predict`:

yhat_logit = predict_mode(mach, Xtest);
first(yhat_logit, 4)

# How does this model perform?

confusion_matrix(yhat_logit, ytest)

# To plot a receiver operator characteristic, we need the *probabilistic* predictions:

yhat = predict(mach, Xtest);
yhat[1:3]

false_positive_rates, true_positive_rates, thresholds =
    roc_curve(yhat, ytest)
plot(false_positive_rates, true_positive_rates)
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black, label=:none)
xlabel!("false positive rate")
ylabel!("true positive rate")

# \fig{EX-creditfraud-roc.svg}

misclassification_rate(yhat_logit, ytest)

# Looks like it's not too bad. Let's see if we can do even better by doing a little
# tuning.

# ‎

# ‎
# @@
# @@dropdown
# ### Tuned logit
# @@
# @@dropdown-content

# Still LogisticClassifier but implementing hyperparameter tuning.

r = range(model_logit, :lambda, lower=1e-6, upper=100, scale=:log)

self_tuning_logit_model = TunedModel(
    model_logit,
    tuning = Grid(resolution=10),
    resampling = CV(nfolds=3),
    range = r,
    measure = misclassification_rate,
)

mach = machine(self_tuning_logit_model, Xtrain, ytrain) |> fit!

# #### Predictions

yhat_logit_tuned = predict_mode(mach, Xtest);

# Let's take a look at the misclassification_rate. It is, surprisingly, slightly higher
# than the one calculated for the non tuned model.

@show misclassification_rate(yhat_logit_tuned, ytest)

# This is lower, although the difference may not be statistically significant.

# ‎

# ‎
# @@
# @@dropdown
# ### Support Vector Machine
# @@
# @@dropdown-content

# #### Initial SVM classification with cost = 1.0:

SVC = @load SVC pkg = LIBSVM

# To fit the SVM, we declare a pipeline which comprises both a standardizer and the
# model. Training is substantially longer than for the preceding linear model (over 10
# minutes):

model_svm = Standardizer() |>  SVC()
mach = machine(model_svm, Xtrain, ytrain) |> fit!
yhat_svm = predict(mach, Xtest)
confusion_matrix(yhat_svm, ytest)

@show misclassification_rate(yhat_svm, ytest)

# #### Tuned SVM

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

# \fig{EX-creditfraud-tuned_svm.svg}

yhat_svm_tuned = predict(mach, Xtest)
confusion_matrix(yhat_svm_tuned, ytest)

misclassification_rate(yhat_svm_tuned, ytest)

# ‎

# ‎
# @@
# @@dropdown
# ### Neural Network
# @@
# @@dropdown-content

NeuralNetworkClassifier = @load NeuralNetworkClassifier pkg=MLJFlux

# We assume familiarity with the building blocks of Flux models. In MLJFlux, a *builder*
# is essentially a rule for creating a Flux chain, once the data has been inspected for
# size. See the [MLJFlux
# documentation](https://github.com/FluxML/MLJFlux.jl/blob/dev/README.md) for further
# details. We do note specify the softmax "finalizer" because MLJFlux classifiers add that
# under the hood.

import MLJFlux.@builder
using Flux

builder = @builder Chain(
    Dense(n_in, 16, relu),
    Dropout(0.1; rng=rng),
    Dense(16, n_out),
)

# In the @builder macro call, `n_in`, `n_out`, and `rng` are replaced with the actual
# number of input features found in the data, the actual number of output classes, and the
# `rng` specified in the model hyperparameters (see below).

# We are now ready to specify the MLJFlux model. If you have running with GPU, you can try
# adding the option `acceleration=CUDALibs()`.

rng = Xoshiro(123)
model = NeuralNetworkClassifier(
    ; builder,
    loss=(yhat, y)->Flux.tversky_loss(yhat, y, β=0.9), # combines precision and recall
    batch_size = round(Int, reduction*2048),
    epochs=50,
    rng,
)

# Although we have not paid attention to it so far (and probably should have) there is
# substantial class imbalance for our target:

StatsBase.countmap(y)

# We will address this by wrapping our model in a SMOTE overampling strategy, using MLJ's
# `BalancedModel` wrapper. Here are options for oversampling:

models("oversampler")

# We'll use SMOTE:

SMOTE = @load SMOTE pkg=Imbalance
balanced_model = BalancedModel(model, oversampler=SMOTE())

# Our final model adds standarization as a pre-processor:

model_nn = Standardizer() |> balanced_model

mach = machine(model_nn, Xtrain, ytrain) |> fit!
yhat_nn = predict_mode(mach, Xtest);
confusion_matrix(yhat_nn, ytest)

misclassification_rate(yhat_nn, ytest)

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Editorial notes
# @@
# @@dropdown-content

# - In the original notebook the train-test-validation split was not stratified.

# - The original raw Flux model has been replaced with an MLJFlux model, for a common
# - interface.

# - MLJ's `BalancedModel` wrapper has been used to correct for class imbalance in the
#   MLJFlux model, using the SMOTE algorithm. Originally, naive oversampling was applied
#   in a separate pre-processing step.

# - In tuning the metric used for the objective function is always
#   `misclassification_rate`, for consistency.

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
