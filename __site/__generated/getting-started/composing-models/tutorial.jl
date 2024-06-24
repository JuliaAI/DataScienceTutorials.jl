# Before running this, please make sure to activate and instantiate the
# tutorial-specific package environment, using this
# [`Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/getting-started/composing-models/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/getting-started/composing-models/Manifest.toml), or by following
# [these](https://juliaai.github.io/DataScienceTutorials.jl/#learning_by_doing) detailed instructions.

# A tutorial showing how to wrap a supervised model in input feature preprocessing (create
# a pipeline model) and transforamtions of the target.

# @@dropdown
# ## Generating dummy data
# @@
# @@dropdown-content

# Let's start by generating some dummy data with both numerical values and categorical values:

using MLJ
import StableRNGs.StableRNG


RidgeRegressor = @load RidgeRegressor pkg=MLJLinearModels

# Here's a table of input features:

X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))

# And a vector target (height in mm):

y = Float64[1780, 1940, 1650, 1730, 1680];

# Note that the scientific type of `age` is `Count` here:

schema(X)

# We will want to coerce that to `Continuous` so that it can be given to a regressor that
# expects such values.

# A typical workflow for such data is to one-hot-encode the categorical data and then
# apply some regression model on the data.

# Let's say that we want to apply the following steps:
# 1. One-hot encode the categorical features in `X`
# 1. Apply a learned Box-Cox transformation to the target `y`
# 1. Train a ridge regression model on the one-hot encoded data and the transformed target.
# 1. Return target prediction on the original scale

# ‎

# ‎
# @@
# @@dropdown
# ## Wrapping a supervised model in learned target transformations
# @@
# @@dropdown-content

# First, we wrap our supervised model in the target transformation we want:

transformed_target_model = TransformedTargetModel(
    RidgeRegressor();
    transformer=UnivariateBoxCoxTransformer(),
)

# Such a model internally transforms the target by applying the Box-Cox transformation
# (that one that makes the data look the most Gaussian) before using it to train the ridge
# regresssor, but it returns target predictions on the original, untransformed
# scale. Here's a demonstration (with contiuous data):

rng = StableRNG(123)
Xcont = (x1 = rand(rng, 5), x2 = rand(5))
mach = machine(transformed_target_model, Xcont, y) |> fit!
yhat = predict(mach, Xcont)

# In case you need convincing, removing the target transformation indeed gives a
# different outcome:

mach = machine(RidgeRegressor(), Xcont, y) |> fit!
yhat - predict(mach, Xcont)

# ‎
# @@
# @@dropdown
# ## The final pipeline
# @@
# @@dropdown-content

# Next we insert our target-transformed model into a pipeline, to create a new model which
# includes the input data pre-processing we want:

pipe = (X -> coerce(X, :age=>Continuous)) |> OneHotEncoder() |> transformed_target_model

# The first element in the pipelines is just an ordinary function to coerce the `:age`
# variable to `Continuous` (needed because `RidgeRegressor` expects `Continuous` input).

# Hyperparameters of this pipeline can be accessed (and set) using dot syntax:

pipe.transformed_target_model_deterministic.model.lambda = 10.0
pipe.one_hot_encoder.drop_last = true;

# Evaluation for a pipe can be done with the `evaluate!` method.

evaluate(pipe, X, y, resampling=CV(nfolds=3), measure=l1)

# ‎

# ‎
# @@

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
