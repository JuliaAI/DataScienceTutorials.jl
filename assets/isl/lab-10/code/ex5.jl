# This file was generated, do not modify it. # hide
PCA = @load PCA pkg=MultivariateStats

pca_mdl = PCA(variance_ratio=1)
pca = machine(pca_mdl, X)
fit!(pca)
PCA
W = MLJ.transform(pca, X);