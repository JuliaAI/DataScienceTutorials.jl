# This file was generated, do not modify it. # hide
KNNClassifier = @load KNNClassifier

knnc = KNNClassifier(K=1)
classif = machine(knnc, X3, y)
fit!(classif, rows=train)
ŷ = predict_mode(classif, rows=test)
accuracy(ŷ, y[test]) |> r3