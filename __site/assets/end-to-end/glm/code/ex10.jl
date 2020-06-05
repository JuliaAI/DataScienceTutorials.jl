# This file was generated, do not modify it. # hide
X = copy(dfX)
y = copy(dfYbinary)

coerce!(X, autotype(X, :string_to_multiclass))
yc = CategoricalArray(y[:, 1])
yc = coerce(yc, OrderedFactor)

@pipeline LinearBinaryClassifierPipe(
            std = Standardizer(),
            hot = OneHotEncoder(drop_last = true),
            reg = LinearBinaryClassifier()
)

LogisticModel = machine(LinearBinaryClassifierPipe(), X, yc)
fit!(LogisticModel)
fp = fitted_params(LogisticModel)