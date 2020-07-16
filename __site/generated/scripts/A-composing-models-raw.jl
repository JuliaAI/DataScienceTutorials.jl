# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ
using PrettyPrinting


@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];

scitype(X.age)

pipe = @pipeline(X -> coerce(X, :age=>Continuous),
                OneHotEncoder(),
                KNNRegressor(K=3),
                target = UnivariateStandardizer());

pipe.knn_regressor.K = 2
pipe.one_hot_encoder.drop_last = true;

evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

