# This file was generated, do not modify it. # hide
clf = machine(BayesianQDA(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)

acc = mean(ŷ .== y[test])