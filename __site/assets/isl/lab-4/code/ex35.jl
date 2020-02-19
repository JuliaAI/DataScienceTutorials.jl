# This file was generated, do not modify it. # hide
ŷ = MLJ.predict(clf, rows=test)

auc(ŷ, y[test])