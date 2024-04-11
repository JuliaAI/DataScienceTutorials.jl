# This file was generated, do not modify it. # hide
KNNClassifier = @load KNNClassifier
MultinomialClassifier = @load MultinomialClassifier pkg=MLJLinearModels;

knn_pipe = Standardizer() |> KNNClassifier()
multinom_pipe = Standardizer() |> MultinomialClassifier()