# This file was generated, do not modify it. # hide
PCA = @load PCA
pca_pipe = Standardizer() |> PCA(maxoutdim=2)
pca = machine(pca_pipe, Xtrain)
fit!(pca)
W = transform(pca, Xtrain)