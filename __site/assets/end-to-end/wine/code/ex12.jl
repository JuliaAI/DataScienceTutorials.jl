# This file was generated, do not modify it. # hide
KNNC = @load KNNClassifier
MNC = @load MultinomialClassifier pkg=MLJLinearModels;

KnnPipe = Standardizer |> KNNC
MnPipe = Standardizer |> MNC