# This file was generated, do not modify it. # hide
@load KNNClassifier pkg=NearestNeighbors

knnc = KNNClassifier(K=1)
clf = machine(knnc, X3, y)
fit!(clf, rows=train)
ŷ = predict_mode(clf, rows=test)
accuracy(ŷ, y[test]) |> r3