# This file was generated, do not modify it. # hide
X = copy(dfX1)
y = copy(dfY1)

coerce!(X, autotype(X, :string_to_multiclass))
yv = Vector(y[:, 1])

@pipeline LinearRegressorPipe(
            std = Standardizer(),
            hot = OneHotEncoder(drop_last = true),
            reg = LinearRegressor()
)

LinearModel = machine(LinearRegressorPipe(), X, yv)
fit!(LinearModel)
fp = fitted_params(LinearModel)