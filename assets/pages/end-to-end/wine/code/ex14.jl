# This file was generated, do not modify it. # hide
@load PCA
pca = machine(PCA(maxoutdim=2), Xtrain)
fit!(pca)
Wtrain = transform(pca, Xtrain);