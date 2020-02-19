# This file was generated, do not modify it. # hide
ŷ = MLJ.predict(mtm, Xtrain)
cross_entropy(ŷ, ytrain) |> mean