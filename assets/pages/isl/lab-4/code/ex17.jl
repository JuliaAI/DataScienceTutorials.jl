# This file was generated, do not modify it. # hide
X3 = select(X2, [:Lag1, :Lag2])
clf = machine(LogisticClassifier(), X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3