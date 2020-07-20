# This file was generated, do not modify it. # hide
@load XGBoostClassifier
dtc = machine(XGBoostClassifier(), Xtrain, ytrain)
fit!(dtc)
ŷ = predict(dtc, Xtrain)
cross_entropy(ŷ, ytrain) |> mean