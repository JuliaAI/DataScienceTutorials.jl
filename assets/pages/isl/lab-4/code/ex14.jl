# This file was generated, do not modify it. # hide
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
mcr = misclassification_rate(ŷ, y[test])
accuracy = 1 - mcr