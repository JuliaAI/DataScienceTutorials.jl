<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/A-composing-models/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

## Generating dummy data
Let's start by generating some dummy data with both numerical values and categorical values:

````julia:ex2
using MLJ
using PrettyPrinting
MLJ.color_off() # hide

KNNRegressor = @load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];
````

Note that the scientific type of `age` is `Count` here:

````julia:ex3
scitype(X.age)
````

We will want to coerce that to `Continuous` so that it can be given to a regressor that expects such values.

## Declaring a pipeline

A typical workflow for such data is to one-hot-encode the categorical data and then apply some regression model on the data.
Let's say that we want to apply the following steps:
1. One hot encode the categorical features in `X`
1. Standardize the target variable (`:height`)
1. Train a KNN regression model on the one hot encoded data and the Standardized target.

The `Pipeline` constructor helps you define such a simple (non-branching) pipeline of steps to be applied in order:

````julia:ex4
pipe = Pipeline(
    coercer = X -> coerce(X, :age=>Continuous),
    one_hot_encoder = OneHotEncoder(),
    transformed_target_model = TransformedTargetModel(
        model = KNNRegressor(K=3);
        target=UnivariateStandardizer()
    )
)
````

Note the coercion of the `:age` variable to Continuous since `KNNRegressor` expects `Continuous` input.
Note also the `TransformedTargetModel` which allows one to learn a transformation (in this case Standardization) of the
target variable to be passed to the `KNNRegressor`.

Hyperparameters of this pipeline can be accessed (and set) using dot syntax:

````julia:ex5
pipe.transformed_target_model.model.K = 2
pipe.one_hot_encoder.drop_last = true;
````

Evaluation for a pipe can be done with the `evaluate!` method; implicitly it will construct machines that will contain the fitted parameters etc:

````julia:ex6
evaluate(
    pipe,
    X,
    height,
    resampling=Holdout(),
    measure=rms
) |> pprint
````

