# This file was generated, do not modify it. # hide
ŷ = MLJ.predict(classif, rows=test)

auc(ŷ, y[test])