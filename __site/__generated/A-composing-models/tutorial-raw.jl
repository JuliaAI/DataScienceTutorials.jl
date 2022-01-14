using MLJ
using PrettyPrinting

KNNRegressor = @load KNNRegressor

X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))

height = [178, 194, 165, 173, 168];

scitype(X.age)

pipe = Pipeline(
    coercer = X -> coerce(X, :age=>Continuous),
    one_hot_encoder = OneHotEncoder(),
    transformed_target_model = TransformedTargetModel(
        model = KNNRegressor(K=3);
        target=UnivariateStandardizer()
    )
)

pipe.transformed_target_model.model.K = 2
pipe.one_hot_encoder.drop_last = true;

evaluate(
    pipe,
    X,
    height,
    resampling=Holdout(),
    measure=rms
) |> pprint

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

