# This file was generated, do not modify it.

using MLJ, PrettyPrinting

@load KNNRegressor
# input
X = (age    = [23, 45, 34, 25, 67],
     gender = categorical(['m', 'm', 'f', 'm', 'f']))
# target
height = [178, 194, 165, 173, 168];

scitype(X.age)

pipe = @pipeline MyPipe(X -> coerce(X, :age=>Continuous),
                       hot = OneHotEncoder(),
                       knn = KNNRegressor(K=3),
                       target = UnivariateStandardizer());

pipe.knn.K = 2
pipe.hot.drop_last = true;

evaluate(pipe, X, height, resampling=Holdout(),
         measure=rms) |> pprint

