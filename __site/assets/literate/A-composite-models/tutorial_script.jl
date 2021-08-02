# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/A-composite-models/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end

using MLJ
using PrettyPrinting
MLJ.color_off() # hide

KNNRegressor = @load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];

scitype(X.age)

pipe = @pipeline(
    X -> coerce(X, :age=>Continuous),
    OneHotEncoder(),
    KNNRegressor(K=3),
    target = UnivariateStandardizer());

pipe.knn_regressor.K = 2
pipe.one_hot_encoder.drop_last = true;

evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

