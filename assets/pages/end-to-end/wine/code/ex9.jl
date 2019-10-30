# This file was generated, do not modify it. # hide
@load KNNClassifier pkg="NearestNeighbors"
@load MultinomialClassifier pkg="MLJLinearModels";

@pipeline KnnPipe(std=Standardizer(), clf=KNNClassifier()) is_probabilistic=true
@pipeline MnPipe(std=Standardizer(), clf=MultinomialClassifier()) is_probabilistic=true