# This file was generated, do not modify it. # hide
# @pipeline PCAPipe(std=Standardizer(), t=PCA(maxoutdim=2))
# pca = machine(PCAPipe(), Xtrain)
# fit!(pca, Xtrain)
# W = transform(pca, Xtrain)

@load PCA

pca = Xc |> Standardizer() |> PCA(maxoutdim=2)
fit!(pca)
W = pca(rows=train);