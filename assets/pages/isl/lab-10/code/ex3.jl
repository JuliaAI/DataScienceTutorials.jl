# This file was generated, do not modify it. # hide
@load PCA pkg=MultivariateStats

@pipeline StdPCA(std = Standardizer(),
                 pca = PCA())

spca_mdl = StdPCA()
spca = machine(spca_mdl, X)
fit!(spca)

W = transform(spca, X);