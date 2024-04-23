# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/getting-started/composing-models/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
import StableRNGs.StableRNG

MLJ.color_off() # hide

RidgeRegressor = @load RidgeRegressor pkg=MLJLinearModels

X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))

y = Float64[1780, 1940, 1650, 1730, 1680];

schema(X)

transformed_target_model = TransformedTargetModel(
    RidgeRegressor();
    transformer=UnivariateBoxCoxTransformer(),
)

rng = StableRNG(123)
Xcont = (x1 = rand(rng, 5), x2 = rand(5))
mach = machine(transformed_target_model, Xcont, y) |> fit!
yhat = predict(mach, Xcont)

mach = machine(RidgeRegressor(), Xcont, y) |> fit!
yhat - predict(mach, Xcont)

pipe = (X -> coerce(X, :age=>Continuous)) |> OneHotEncoder() |> transformed_target_model

pipe.transformed_target_model_deterministic.model.lambda = 10.0
pipe.one_hot_encoder.drop_last = true;

evaluate(pipe, X, y, resampling=CV(nfolds=3), measure=l1)
