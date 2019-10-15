# Before running this, make sure to instantiate the environment corresponding to
# [this `Project.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Project.toml)
# and [this `Manifest.toml`](https://raw.githubusercontent.com/tlienart/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials.
#
# To do so, copy both files in a folder, start Julia in that folder and
#
# ```julia
# using Pkg
# Pkg.activate(".")
# Pkg.instantiate()
# ```

using MLJ, PrettyPrinting

@load KNNRegressor
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
height = [178, 194, 165, 173, 168];

scitype_union(X.age)

pipe = @pipeline MyPipe(X -> coerce(X, :age=>Continuous),
                       hot = OneHotEncoder(),
                       knn = KNNRegressor(K=3),
                       target = UnivariateStandardizer());

pipe.knn.K = 2
pipe.hot.drop_last = true;

evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

