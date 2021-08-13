# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-composing-models/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/A-composing-models/Manifest.toml).
# For instance, copy these files to a folder 'A-composing-models', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/A-composing-models/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
using PrettyPrinting


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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

