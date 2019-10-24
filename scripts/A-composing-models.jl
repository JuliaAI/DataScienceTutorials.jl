# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ, PrettyPrinting

@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
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

