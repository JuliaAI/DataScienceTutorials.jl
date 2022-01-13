# This file was generated, do not modify it. # hide
XGBC = @load XGBoostClassifier
dtc = machine(XGBC(), Xtrain, ytrain)
fit!(dtc)
ŷ = MLJ.predict(dtc, Xtrain)
cross_entropy(ŷ, ytrain) |> mean