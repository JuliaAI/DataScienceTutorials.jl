# This file was generated, do not modify it. # hide
pipe = Pipeline(
    coercer = X -> coerce(X, :age=>Continuous),
    one_hot_encoder = OneHotEncoder(),
    transformed_target_model = TransformedTargetModel(
        model = KNNRegressor(K=3);
        target=UnivariateStandardizer()
    )
)