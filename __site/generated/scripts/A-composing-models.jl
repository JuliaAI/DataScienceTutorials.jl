# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Generating dummy data
# Let's start by generating some dummy data with both numerical values and categorical values:
using MLJ
using PrettyPrinting


@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];

# Note that the scientific type of `age` is `Count` here:
scitype(X.age)

# We will want to coerce that to `Continuous` so that it can be given to a regressor that expects such values.
# ## Declaring a pipeline
# A typical workflow for such data is to one-hot-encode the categorical data and then apply some regression model on the data.# Let's say that we want to apply the following steps:# 1. standardize the target variable (`:height`)# 1. one hot encode the categorical data# 1. train a KNN regression model
# The `@pipeline` macro helps you define such a simple (non-branching) pipeline of steps to be applied in order:
pipe = @pipeline(X -> coerce(X, :age=>Continuous),
                OneHotEncoder(),
                KNNRegressor(K=3),
                target = UnivariateStandardizer());

# Note the coercion of the `:age` variable to Continuous since `KNNRegressor` expects `Continuous` input.# Note also the `target` keyword where you can specify a transformation of the target variable.
# Hyperparameters of this pipeline can be accessed (and set) using dot syntax:
pipe.knn_regressor.K = 2
pipe.one_hot_encoder.drop_last = true;

# Evaluation for a pipe can be done with the `evaluate!` method; implicitly it will construct machines that will contain the fitted parameters etc:
evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

