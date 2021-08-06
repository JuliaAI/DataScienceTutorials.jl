# This file was generated, do not modify it. # hide
KNNC = @load KNNClassifier
MNC = @load MultinomialClassifier pkg=MLJLinearModels;

KnnPipe = @pipeline(Standardizer(), KNNC())
MnPipe = @pipeline(Standardizer(), MNC());