# This file was generated, do not modify it. # hide
pipe = @pipeline(X -> coerce(X, :age=>Continuous),
                OneHotEncoder(),
                KNNRegressor(K=3),
                target = UnivariateStandardizer());