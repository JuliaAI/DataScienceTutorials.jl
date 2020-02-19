# This file was generated, do not modify it. # hide
pipe = @pipeline MyPipe(X -> coerce(X, :age=>Continuous),
                       hot = OneHotEncoder(),
                       knn = KNNRegressor(K=3),
                       target = UnivariateStandardizer());