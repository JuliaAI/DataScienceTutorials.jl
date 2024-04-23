using Pkg # hideall
Pkg.activate("_literate/end-to-end/telco/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# An application of the [MLJ
# toolbox](https://alan-turing-institute.github.io/MLJ.jl/dev/) to the
# Telco Customer Churn dataset, aimed at practicing data scientists
# new to MLJ (Machine Learning in Julia). This tutorial does not
# cover exploratory data analysis.

# MLJ is a general machine learning toolbox (i.e., not just
# deep-learning).

# For other MLJ learning resources see the [Learning
# MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_mlj/)
# section of the
# [manual](https://alan-turing-institute.github.io/MLJ.jl/dev/).

# **Topics covered**: Grabbing and preparing a dataset, basic
# fit/predict workflow, constructing a pipeline to include data
# pre-processing, estimating performance metrics, ROC curves, confusion
# matrices, feature importance, basic feature selection, controlling iterative
# models, hyper-parameter optimization (tuning).

# **Prerequisites for this tutorial.** Previous experience building,
# evaluating, and optimizing machine learning models using
# scikit-learn, caret, MLR, weka, or similar tool. No previous
# experience with MLJ. Only fairly basic familiarity with Julia is
# required. Uses
# [DataFrames.jl](https://dataframes.juliadata.org/stable/) but in a
# minimal way ([this
# cheatsheet](https://ahsmart.com/pub/data-wrangling-with-data-frames-jl-cheat-sheet/index.html)
# may help).

# **Time.** Between two and three hours, first time through.

# @@dropdown
# ## Summary of methods and types introduced
# @@
# @@dropdown-content

# |code   | purpose|
# |:-------|:-------------------------------------------------------|
# | `OpenML.load(id)` | grab a dataset from [OpenML.org](https://www.openml.org)|
# | `scitype(X)`      | inspect the scientific type (scitype) of object `X`|
# | `schema(X)`       | inspect the column scitypes (scientific types) of a table `X`|
# | `coerce(X, ...)`   | fix column encodings to get appropriate scitypes|
# | `partition(data, frac1, frac2, ...; rng=...)` | vertically split `data`, which can be a table, vector or matrix|
# | `unpack(table, f1, f2, ...)` | horizontally split `table` based on conditions `f1`, `f2`, ..., applied to column names|
# | `@load ModelType pkg=...`           | load code defining a model type|
# | `input_scitype(model)` | inspect the scitype that a model requires for features (inputs)|
# | `target_scitype(model)`| inspect the scitype that a model requires for the target (labels)|
# | `ContinuousEncoder`   | built-in model type for re-encoding all features as `Continuous`|
# | `model1 ∣> model2 ∣> ...` | combine multiple models into a pipeline|
# | `measures("under curve")` | list all measures (metrics) with string "under curve" in documentation|
# | `accuracy(yhat, y)` | compute accuracy of predictions `yhat` against ground truth observations `y`|
# | `auc(yhat, y), brier_loss(yhat, y)` | evaluate two probabilistic measures (`yhat` a vector of probability distributions)|
# | `machine(model, X, y)` | bind `model` to training data `X` (features) and `y` (target)|
# | `fit!(mach, rows=...)` | train machine using specified rows (observation indices)|
# | `predict(mach, rows=...)`, | make in-sample model predictions given specified rows|
# | `predict(mach, Xnew)` | make predictions given new features `Xnew`|
# | `fitted_params(mach)` | inspect learned parameters|
# | `report(mach)`        | inspect other outcomes of training|
# | `feature_importances(mach)` | inspect feature importances, where reported |
# | `confmat(yhat, y)`    | confusion matrix for predictions `yhat` and ground truth `y`|
# | `roc(yhat, y)` | compute points on the receiver-operator Characteristic|
# | `StratifiedCV(nfolds=6)` | 6-fold stratified cross-validation resampling strategy|
# | `Holdout(fraction_train=0.7)` | holdout resampling strategy|
# | `evaluate(model, X, y; resampling=..., options...)` | estimate performance metrics for `model` using the data `X`, `y`|
# | `FeatureSelector()` | transformer for selecting features|
# | `Step(3)` | iteration control for stepping 3 iterations|
# | `NumberSinceBest(6)`, `TimeLimit(60/5), InvalidValue()` | stopping criterion iteration controls|
# | `IteratedModel(model=..., controls=..., options...)` | wrap an iterative `model` in controls|
# | `range(model,  :some_hyperparam, lower=..., upper=...)` | define a numeric range|
# | `RandomSearch()` | random search tuning strategy|
# | `TunedModel(model=..., tuning=..., options...)` | wrap the supervised `model` in specified `tuning` strategy|



# ‎
# @@
# @@dropdown
# ## Warm up: Building a model for the iris dataset
# @@
# @@dropdown-content

# Before turning to the Telco Customer Churn dataset, we very quickly
# build a predictive model for Fisher's well-known iris data set, as way of
# introducing the main actors in any MLJ workflow. Details that you
# don't fully grasp should become clearer in the Telco study.

# This section is a condensed adaption of the [Getting Started
# example](https://alan-turing-institute.github.io/MLJ.jl/dev/getting_started/#Fit-and-predict)
# in the MLJ documentation.

# First, using the built-in iris dataset, we load and inspect the features
# `X_iris` (a table) and target variable `y_iris` (a vector):

using MLJ

#-

X_iris, y_iris = @load_iris;
schema(X_iris)

#-

y_iris[1:4]

#

levels(y_iris)

# We load a decision tree model, from the package DecisionTree.jl:

DecisionTree = @load DecisionTreeClassifier pkg=DecisionTree # model type
model = DecisionTree(min_samples_split=5)                    # model instance

# In MLJ, a *model* is just a container for hyper-parameters of
# some learning algorithm. It does not store learned parameters.

# Next, we bind the model together with the available data in what's
# called a *machine*:

mach = machine(model, X_iris, y_iris)

# A machine is essentially just a model (ie, hyper-parameters) plus data, but
# it additionally stores *learned parameters* (the tree) once it is
# trained on some view of the data:

train_rows = vcat(1:60, 91:150); # some row indices (observations are rows not columns)
fit!(mach, rows=train_rows)
fitted_params(mach)

# A machine stores some other information enabling [warm
# restart](https://alan-turing-institute.github.io/MLJ.jl/dev/machines/#Warm-restarts)
# for some models, but we won't go into that here. You are allowed to
# access and mutate the `model` parameter:

mach.model.min_samples_split  = 10
fit!(mach, rows=train_rows) # re-train with new hyper-parameter

# Now we can make predictions on some other view of the data, as in

predict(mach, rows=71:73)

# or on completely new data, as in

Xnew = (sepal_length = [5.1, 6.3],
        sepal_width = [3.0, 2.5],
        petal_length = [1.4, 4.9],
        petal_width = [0.3, 1.5])
yhat = predict(mach, Xnew)

# These are probabilistic predictions which can be manipulated using a
# widely adopted interface defined in the Distributions.jl
# package. For example, we can get raw probabilities like this:

pdf.(yhat, "virginica")

# A single prediction is displayed like this:

yhat[2]

# We now turn to the Telco dataset.
# ‎
# @@
# @@dropdown
# ## Getting the Telco data
# @@
# @@dropdown-content

import DataFrames

#-

data = OpenML.load(42178) # data set from OpenML.org
df0 = DataFrames.DataFrame(data)
first(df0, 4)

# The object of this tutorial is to build and evaluate supervised
# learning models to predict the `Churn` variable, a binary variable
# measuring customer retention, based on other variables that are
# relevant.

# In the table, observations correspond to rows, and features to
# columns, which is the convention for representing all
# two-dimensional data in MLJ.

# ‎
# @@
# @@dropdown
# ## Type coercion
# @@
# @@dropdown-content

# *Introduces:* `scitype`, `schema`, `coerce`

# A ["scientific
# type"](https://juliaai.github.io/ScientificTypes.jl/dev/) or
# *scitype* indicates how MLJ will *interpret* data. For example,
# `typeof(3.14) == Float64`, while `scitype(3.14) == Continuous` and
# also `scitype(3.14f0) == Continuous`. In MLJ, model data
# requirements are articulated using scitypes.

# Here are common "scalar" scitypes:

# \figalt{scalar scitypesb}{./scitypes.svg}

# There are also container scitypes. For example, the scitype of any
# `N`-dimensional array is `AbstractArray{S, N}`, where `S` is the scitype of the
# elements:

scitype(["cat", "mouse", "dog"])

# The `schema` operator summarizes the column scitypes of a table:

schema(df0) |> DataFrames.DataFrame  # converted to DataFrame for better display

# All of the fields being interpreted as `Textual` are really
# something else, either `Multiclass` or, in the case of
# `TotalCharges`, `Continuous`. In fact, `TotalCharges` is
# mostly floats wrapped as strings. However, it needs special
# treatment because some elements consist of a single space, " ",
# which we'll treat as "0.0".

fix_blanks(v) = map(v) do x
    if x == " "
        return "0.0"
    else
        return x
    end
end

df0.TotalCharges = fix_blanks(df0.TotalCharges);

# Coercing the `TotalCharges` type to ensure a `Continuous` scitype:

coerce!(df0, :TotalCharges => Continuous);

# Coercing all remaining `Textual` data to `Multiclass`:

coerce!(df0, Textual => Multiclass);

# Finally, we'll coerce our target variable `Churn` to be
# `OrderedFactor`, rather than `Multiclass`, to enable a reliable
# interpretation of metrics like "true positive rate".  By convention,
# the first class is the negative one:

coerce!(df0, :Churn => OrderedFactor)
levels(df0.Churn) # to check order

# Re-inspecting the scitypes:

schema(df0) |> DataFrames.DataFrame

# ‎
# @@
# @@dropdown
# ## Preparing a holdout set for final testing
# @@
# @@dropdown-content

# *Introduces:* `partition`

# To reduce training times for the purposes of this tutorial, we're
# going to dump 90% of observations (after shuffling) and split off
# 30% of the remainder for use as a lock-and-throw-away-the-key
# holdout set.

import Random.Xoshiro
rng = Xoshiro(123)
df, df_test, df_dumped = partition(df0, 0.07, 0.03; # in ratios 7:3:90
                                   stratify=df0.Churn,
                                   rng=rng);

# The reader interested in including all data can instead do
# `df, df_test = partition(df0, 0.7; rng=rng )`.

# We have included the option `stratify=df0.Churn` to ensure the `Churn` classes have
# similary distributions in `df` and `df_test`.

# ‎
# @@
# @@dropdown
# ## Splitting data into target and features
# @@
# @@dropdown-content

# *Introduces:* `unpack`

# In the following call, the column with name `Churn` is copied over
# to a vector `y`, and every remaining column, except `customerID`
# (which contains no useful information) goes into a table `X`. Here
# `Churn` is the target variable for which we seek predictions, given
# new versions of the features `X`.

y, X = unpack(df, ==(:Churn), !=(:customerID));
schema(X).names

#-

intersect([:Churn, :customerID], schema(X).names)

# We'll do the same for the holdout data:

ytest, Xtest = unpack(df_test, ==(:Churn), !=(:customerID));

# ‎
# @@
# @@dropdown
# ## Loading a model and checking type requirements
# @@
# @@dropdown-content

# *Introduces:* `@load`, `input_scitype`, `target_scitype`

# For tools helping us to identify suitable models, see the [Model
# Search](https://alan-turing-institute.github.io/MLJ.jl/dev/model_search/#model_search)
# section of the manual. We will build a gradient tree-boosting model,
# a popular first choice for structured data like we have here. Model
# code is contained in a third-party package called
# [EvoTrees.jl](https://github.com/Evovest/EvoTrees.jl) which is
# loaded as follows:

Booster = @load EvoTreeClassifier pkg=EvoTrees

# Recall that a *model* is just a container for some algorithm's
# hyper-parameters. Let's create a `Booster` with default values for
# the hyper-parameters:

booster = Booster()

# This model is appropriate for the kind of target variable we have because of
# the following passing test:

scitype(y) <: target_scitype(booster)

# Our features `X` are also compatible with `booster`:

scitype(X) <: input_scitype(booster)

# The majority of MLJ supervised models expects all features to be `Continuous` (and this
# used to be true for an earlier version of the EvoTrees.jl models.). For the sake of
# illustration, we will pretend this is true here, and introduce our own
# categorical feature encoding, discussed next.

# To see a list of all models that directly support the data (`X`, `y`) we can do this:

models(matching(X, y))

# ‎
# @@
# @@dropdown
# ## Building a model pipeline to incorporate feature encoding
# @@
# @@dropdown-content

# *Introduces:* `ContinuousEncoder`, pipeline operator `|>`

# The built-in `ContinuousEncoder` model transforms an arbitrary table
# to a table whose features are all `Continuous` (dropping any fields
# it does not know how to encode). In particular, all `Multiclass`
# features are one-hot encoded.

# A *pipeline* is a stand-alone model that internally combines one or
# more models in a linear (non-branching) pipeline. Here's a pipeline
# that adds the `ContinuousEncoder` as a pre-processor to the
# gradient tree-boosting model above:

pipe = ContinuousEncoder() |> booster

# Note that the component models appear as hyper-parameters of
# `pipe`. Pipelines are an implementation of a more general [model
# composition](https://alan-turing-institute.github.io/MLJ.jl/dev/composing_models/#Composing-Models)
# interface provided by MLJ that advanced users may want to learn about.

# From the above display, we see that component model hyper-parameters
# are now *nested*, but they are still accessible (important in hyper-parameter
# optimization):

pipe.evo_tree_classifier.max_depth

# ‎
# @@
# @@dropdown
# ## Evaluating the pipeline model's performance
# @@
# @@dropdown-content

# *Introduces:* `measures` (function), **measures:** `brier_loss`,
#  `auc`, `accuracy`; `machine`, `fit!`, `predict`, `fitted_params`,
#  `report`, `roc`, **resampling strategy** `StratifiedCV`,
#  `evaluate`, `FeatureSelector`, `feature_importances`

# Without touching our test set `Xtest`, `ytest`, we will estimate the
# performance of our pipeline model, with default hyper-parameters, in
# two different ways:

# **Evaluating by hand.** First, we'll do this "by hand" using the `fit!` and `predict`
# workflow illustrated for the iris data set above, using a
# holdout resampling strategy. At the same time we'll see how to
# generate a **confusion matrix**, **ROC curve**, and inspect
# **feature importances**.

# **Automated performance evaluation.** Next we'll apply the more
# typical and convenient `evaluate` workflow, but using `StratifiedCV`
# (stratified cross-validation) which is more informative.

# In any case, we need to choose some measures (metrics) to quantify
# the performance of our model. For a complete list of measures, one
# does `measures()`. Or we also can do:

measures("Brier")

# We will be primarily using `brier_loss`, but also `auc` (area under
# the ROC curve) and `accuracy`.

# @@dropdown
# ### Evaluating by hand (with a holdout set)
# @@
# @@dropdown-content

# Our pipeline model can be trained just like the decision tree model
# we built for the iris data set. Binding all non-test data to the
# pipeline model:

mach_pipe = machine(pipe, X, y)

# We already encountered the `partition` method above. Here we apply
# it to row indices, instead of data containers, as `fit!` and
# `predict` only need a *view* of the data to work.

train, validation = partition(1:length(y), 0.7)
fit!(mach_pipe, rows=train)

# We note in passing that we can access two kinds of information from a trained machine:

# - The **learned parameters** (eg, coefficients of a linear model): We use
#   `fitted_params(mach_pipe)`

# - Other **by-products of training** (eg, p-values): We use
#   `report(mach_pipe)`

fp = fitted_params(mach_pipe);
keys(fp)

# For example, we can extract the raw EvoTrees.jl learned parameter object:

fp.evo_tree_classifier.fitresult

# And, from the report, extract the names of all features generated for the one-hot
# encoding:

rpt = report(mach_pipe);
keys(rpt.continuous_encoder)

#-

join(string.(rpt.continuous_encoder.new_features), ", ") |> println

# Another example of information sometimes appearing in a report is feature
# importances. However, for models supporting feature importances, they are always
# available directly.

reports_feature_importances(pipe)

# This hods because the supervised component of our pipeline supports feature imporances:

reports_feature_importances(booster)

# And we can get the booster feature imporances from the pipeline's machine like this:

fi = feature_importances(mach_pipe)

# which we'll put into data frame for later:

feature_importance_table =
    (feature=Symbol.(first.(fi)), importance=last.(fi)) |> DataFrames.DataFrame;

# For models not reporting feature importances, we recommend the
# [Shapley.jl](https://expandingman.gitlab.io/Shapley.jl/) package.

# Returning to predictions and evaluations of our measures:

ŷ = predict(mach_pipe, rows=validation);
print(
    "Measurements:\n",
    "  brier loss: ", brier_loss(ŷ, y[validation]), "\n",
    "  auc:        ", auc(ŷ, y[validation]),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ), y[validation])
)

# Note that we need `mode` in the last case because `accuracy` expects
# point predictions, not probabilistic ones. (One can alternatively
# use `predict_mode` to generate the predictions.)

# While we're here, lets also generate a **confusion matrix** and
# [receiver-operator
# characteristic](https://en.wikipedia.org/wiki/Receiver_operating_characteristic)
# (ROC):

confmat(mode.(ŷ), y[validation])

# Note: Importing the plotting package and calling the plotting
# functions for the first time can take a minute or so.

using Plots
Plots.scalefontsizes() #hide # reset font sizes
Plots.scalefontsizes(0.85)

#-

roc = roc_curve(ŷ, y[validation])
plt = scatter(roc, legend=false)
plot!(plt, xlab="false positive rate", ylab="true positive rate")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)

savefig(joinpath(@OUTPUT, "EX-telco-roc.svg")); # hide

# \fig{EX-telco-roc.svg}

# (Warning here is a [minor bug](https://github.com/Evovest/EvoTrees.jl/issues/267).)


# ‎
# @@
# @@dropdown
# ### Automated performance evaluation (more typical workflow)
# @@
# @@dropdown-content

# We can also get performance estimates with a single call to the
# `evaluate` function, which also allows for more complicated
# resampling - in this case stratified cross-validation. To make this
# more comprehensive, we set `repeats=3` below to make our
# cross-validation "Monte Carlo" (3 random size-6 partitions of the
# observation space, for a total of 18 folds) and set
# `acceleration=CPUThreads()` to parallelize the computation.

# We choose a `StratifiedCV` resampling strategy; the complete list of options is
# [here](https://alan-turing-institute.github.io/MLJ.jl/dev/evaluating_model_performance/#Built-in-resampling-strategies).

e_pipe = evaluate(pipe, X, y,
                  resampling=StratifiedCV(nfolds=6, rng=rng),
                  measures=[brier_loss, auc, accuracy],
                  repeats=3,
                  acceleration=CPUThreads())

# (There is also a version of `evaluate` for machines. Query the
# `evaluate` and `evaluate!` doc-strings to learn more about these
# functions and what the `PerformanceEvaluation` object `e_pipe` records.)

# While [less than ideal](https://arxiv.org/abs/2104.00673), let's adopt the common
# practice of using the standard error of a cross-validation score as an estimate of the
# uncertainty of a performance measure's expected value. To get a 95% confidence interval
# based on this error, use "measurement ± delta" where "delta" is the number in the
# "1.96*SE" column.

# ‎
# @@

# ‎
# @@
# @@dropdown
# ## Filtering out unimportant features
# @@
# @@dropdown-content

# *Introduces:* `FeatureSelector`

# Before continuing, we'll modify our pipeline to drop those features
# with low feature importance, to speed up later optimization:

unimportant_features = filter(:importance => <(0.005), feature_importance_table).feature

pipe2 = ContinuousEncoder() |>
    FeatureSelector(features=unimportant_features, ignore=true) |> booster

# ‎
# @@
# @@dropdown
# ## Wrapping our iterative model in control strategies
# @@
# @@dropdown-content

# *Introduces:* **control strategies:** `Step`, `NumberSinceBest`, `TimeLimit`,
# `InvalidValue`, **model wrapper** `IteratedModel`, **resampling strategy:** `Holdout`

# We want to optimize the hyper-parameters of our model. Since our
# model is iterative, these parameters include the (nested) iteration
# parameter `pipe.evo_tree_classifier.nrounds`. Sometimes this
# parameter is optimized first, fixed, and then maybe optimized again
# after the other parameters. Here we take a more principled approach,
# **wrapping our model in a control strategy** that makes it
# "self-iterating". The strategy applies a stopping criterion to
# *out-of-sample* estimates of the model performance, constructed
# using an internally constructed holdout set. In this way, we avoid
# some data hygiene issues, and, when we subsequently optimize other
# parameters, we will always being using an optimal number of
# iterations.

# Note that this approach can be applied to any iterative MLJ model,
# eg, the neural network models provided by
# [MLJFlux.jl](https://github.com/FluxML/MLJFlux.jl).

# First, we select appropriate controls from [this
# list](https://alan-turing-institute.github.io/MLJ.jl/dev/controlling_iterative_models/#Controls-provided):

controls = [
    Step(1),              # to increment iteration parameter (`pipe.nrounds`)
    NumberSinceBest(4),   # main stopping criterion
    TimeLimit(2/3600),    # never train more than 2 sec
    InvalidValue()        # stop if NaN or ±Inf encountered
]

# Now we wrap our pipeline model using the `IteratedModel` wrapper,
# being sure to specify the `measure` on which internal estimates of
# the out-of-sample performance will be based:

iterated_pipe = IteratedModel(model=pipe2,
                              controls=controls,
                              measure=brier_loss,
                              resampling=Holdout(fraction_train=0.7))

# We've set `resampling=Holdout(fraction_train=0.7)` to arrange that
# data attached to our model should be internally split into a train
# set (70%) and a holdout set (30%) for determining the out-of-sample
# estimate of the Brier loss.

# For demonstration purposes, let's bind `iterated_model` to all data
# not in our don't-touch holdout set, and train on all of that data:

mach_iterated_pipe = machine(iterated_pipe, X, y)
fit!(mach_iterated_pipe);

# To recap, internally this training is split into two separate steps:

# - A controlled iteration step, training on the holdout set, with the total number of
#   iterations determined by the specified stopping criteria (based on the out-of-sample
#   performance estimates)


# - A final step that trains the atomic model on *all* available data using the number of
#   iterations determined in the first step. Calling `predict` on `mach_iterated_pipe`
#   means using the learned parameters of the second step.

# ‎
# @@
# @@dropdown
# ## Hyper-parameter optimization (model tuning)
# @@
# @@dropdown-content

# *Introduces:* `range`, **model wrapper** `TunedModel`, `RandomSearch`

# We now turn to hyper-parameter optimization. A tool not discussed
# here is the `learning_curve` function, which can be useful when
# wanting to visualize the effect of changes to a *single*
# hyper-parameter (which could be an iteration parameter). See, for
# example, [this section of the
# manual](https://alan-turing-institute.github.io/MLJ.jl/dev/learning_curves/)
# or [this
# tutorial](https://github.com/ablaom/MLJTutorial.jl/blob/dev/notebooks/04_tuning/notebook.ipynb).

# Fine tuning the hyper-parameters of a gradient booster can be
# somewhat involved. Here we settle for simultaneously optimizing two
# key parameters: `max_depth` and `η` (learning_rate).

# Like iteration control, **model optimization in MLJ is implemented as
# a model wrapper**, called `TunedModel`. After wrapping a model in a
# tuning strategy and binding the wrapped model to data in a machine
# called `mach`, calling `fit!(mach)` instigates a search for optimal
# model hyperparameters, within a specified range, and then uses all
# supplied data to train the best model. To predict using that model,
# one then calls `predict(mach, Xnew)`. In this way the wrapped model
# may be viewed as a "self-tuning" version of the unwrapped
# model. That is, wrapping the model simply transforms certain
# hyper-parameters into learned parameters (just as `IteratedModel`
# does for an iteration parameter).

# To start with, we define ranges for the parameters of
# interest. Since these parameters are nested, let's force a
# display of our model to a larger depth:

show(iterated_pipe, 2)

#-

p1 = :(model.evo_tree_classifier.eta)
p2 = :(model.evo_tree_classifier.max_depth)

r1 = range(iterated_pipe, p1, lower=-2, upper=-0.5, scale=x->10^x)
r2 = range(iterated_pipe, p2, lower=2, upper=6)

# Nominal ranges are defined by specifying `values` instead of `lower`
# and `upper`.

# Next, we choose an optimization strategy from [this
# list](https://alan-turing-institute.github.io/MLJ.jl/dev/tuning_models/#Tuning-Models):

tuning = RandomSearch(rng=rng)

# Then we wrap the model, specifying a `resampling` strategy and a
# `measure`, as we did for `IteratedModel`.  In fact, we can include a
# battery of `measures`; by default, optimization is with respect to
# performance estimates based on the first measure, but estimates for
# all measures can be accessed from the model's `report`.

# The keyword `n` specifies the total number of models (sets of
# hyper-parameters) to evaluate.

tuned_iterated_pipe = TunedModel(model=iterated_pipe,
                                 range=[r1, r2],
                                 tuning=tuning,
                                 measures=[brier_loss, auc, accuracy],
                                 resampling=StratifiedCV(nfolds=6, rng=rng),
                                 acceleration=CPUThreads(),
                                 n=40)

# To save time, we skip the `repeats` here.

# Binding our final model to data and training:

mach_tuned_iterated_pipe = machine(tuned_iterated_pipe, X, y)
fit!(mach_tuned_iterated_pipe)

# As explained above, the training we have just performed was split
# internally into two separate steps:

# - A step to determine the parameter values that optimize the aggregated cross-validation scores
# - A final step that trains the optimal model on *all* available data. Future predictions `predict(mach_tuned_iterated_pipe, ...)` are based on this final training step.

# From `report(mach_tuned_iterated_pipe)` we can extract details about
# the optimization procedure. For example:

rpt2 = report(mach_tuned_iterated_pipe);
best_booster = rpt2.best_model.model.evo_tree_classifier

print(
    "Optimal hyper-parameters: \n",
    "  max_depth: ", best_booster.max_depth, "\n",
    "  eta:         ", best_booster.eta
)

#-

e_best = rpt2.best_history_entry
e_best.evaluation

# Digging a little deeper, we can learn what stopping criterion was
# applied in the case of the optimal model, and how many iterations
# were required:

rpt2.best_report.controls |> collect

# Finally, we can visualize the optimization results:

plot(mach_tuned_iterated_pipe, size=(600,450))

savefig(joinpath(@OUTPUT, "EX-telco-tuning.svg")); # hide

# \fig{EX-telco-tuning.svg}



# ‎
# @@
# @@dropdown
# ## Saving our model
# @@
# @@dropdown-content

# *Introduces:* `MLJ.save`

# Here's how to serialize our final, trained self-iterating,
# self-tuning pipeline machine using Julia's native serializer (see
# [the
# manual](https://alan-turing-institute.github.io/MLJ.jl/dev/machines/#Saving-machines)
# for more options):

MLJ.save("tuned_iterated_pipe.jls", mach_tuned_iterated_pipe)

# We'll deserialize this in "Testing the final model" below.

# ‎
# @@
# @@dropdown
# ## Final performance estimate
# @@
# @@dropdown-content

# Finally, to get an even more accurate estimate of performance, we
# can evaluate our model using stratified cross-validation and all the
# data attached to our machine. Because this evaluation implies
# [nested
# resampling](https://mlr.mlr-org.com/articles/tutorial/nested_resampling.html),
# this computation takes quite a bit longer than the previous one
# (which is being repeated six times, using 5/6th of the data each
# time):

e_tuned_iterated_pipe = evaluate(tuned_iterated_pipe, X, y,
                                 resampling=StratifiedCV(nfolds=6, rng=rng),
                                 measures=[brier_loss, auc, accuracy])


# For comparison, here again is the evaluation for the basic
# pipeline model (no feature selection and default hyperparameters):

e_pipe

# Tuning appears to improve all three scores (not just the Brier loss used in
# optimization). However, 95% confidence intervals, based on the standard errors, suggest
# we are not detecting statistically significant differences for `auc` and `accuracy`. In
# any case, the default `booster` hyper-parameters do a pretty good job. But it would
# definitely be worth revisiting this in the case we use all the data.

# @@
# @@dropdown
# ## Testing the final model
# @@
# @@dropdown-content

# We now determine the performance of our model on our
# lock-and-throw-away-the-key holdout set. To demonstrate
# deserialization, we'll pretend we're in a new Julia session (but
# have called import/using on the same packages). Then the
# following should suffice to recover our model trained under
# "Hyper-parameter optimization" above:

mach_restored = machine("tuned_iterated_pipe.jls")

# We compute predictions on the holdout set:

ŷ_tuned = predict(mach_restored, Xtest);
ŷ_tuned[1]

# And can compute the final performance measures:

print(
    "Tuned model measurements on test:\n",
    "  brier loss: ", brier_loss(ŷ_tuned, ytest), "\n",
    "  auc:        ", auc(ŷ_tuned, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_tuned), ytest)
)

# For comparison, here's the performance for the basic pipeline model

mach_basic = machine(pipe, X, y)
fit!(mach_basic, verbosity=0)

ŷ_basic = predict(mach_basic, Xtest);

print(
    "Basic model measurements on test set:\n",
    "  brier loss: ", brier_loss(ŷ_basic, ytest), "\n",
    "  auc:        ", auc(ŷ_basic, ytest),                "\n",
    "  accuracy:   ", accuracy(mode.(ŷ_basic), ytest)
)

rm("tuned_iterated_pipe.jls") # hide

# ‎
# @@
