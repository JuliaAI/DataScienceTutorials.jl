# This file was generated, do not modify it. # hide
transformed_target_model = TransformedTargetModel(
    RidgeRegressor();
    transformer=UnivariateBoxCoxTransformer(),
)