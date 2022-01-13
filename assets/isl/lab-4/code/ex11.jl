# This file was generated, do not modify it. # hide
fit!(classif)
ŷ = MLJ.predict(classif, X2)
ŷ[1:3]