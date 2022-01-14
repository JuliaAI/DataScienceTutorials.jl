# This file was generated, do not modify it. # hide
X = copy(dfX)
y = copy(dfYbinary)

coerce!(X, autotype(X, :string_to_multiclass))
yc = CategoricalArray(y[:, 1])
yc = coerce(yc, OrderedFactor)

LinearBinaryClassifierPipe = Pipeline(
    Standardizer(),
    OneHotEncoder(drop_last = true),
    LinearBinaryClassifier()
)

LogisticModel = machine(LinearBinaryClassifierPipe, X, yc)
fit!(LogisticModel)
fp = fitted_params(LogisticModel)