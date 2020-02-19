<!--This file was generated, do not modify it.-->
## Generating dummy data

Let's start by generating some dummy data with both numerical values and categorical values:

```julia:ex1
using MLJ, PrettyPrinting

@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];
```

Note that the scientific type of `age` is `Count` here:

```julia:ex2
scitype(X.age)
```

We will want to coerce that to `Continuous` so that it can be given to a regressor that expects such values.

## Declaring a pipeline

A typical workflow for such data is to one-hot-encode the categorical data and then apply some regression model on the data.
Let's say that we want to apply the following steps:
1. standardize the target variable (`:height`)
1. one hot encode the categorical data
1. train a KNN regression model

The `@pipeline` macro helps you define such a simple (non-branching) pipeline of steps to be applied in order:

```julia:ex3
pipe = @pipeline MyPipe(X -> coerce(X, :age=>Continuous),
                       hot = OneHotEncoder(),
                       knn = KNNRegressor(K=3),
                       target = UnivariateStandardizer());
```

Note the coercion of the `:age` variable to Continuous since `KNNRegressor` expects `Continuous` input.
Note also the `target` keyword where you can specify a transformation of the target variable.

Hyperparameters of this pipeline can be accessed (and set) using dot syntax:

```julia:ex4
pipe.knn.K = 2
pipe.hot.drop_last = true;
```

Evaluation for a pipe can be done with the `evaluate!` method; implicitly it will construct machines that will contain the fitted parameters etc:

```julia:ex5
evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint
```

