# This file was generated, do not modify it. # hide
Random.seed!(1515)

@pipeline SPCA(std = Standardizer(),
               pca = PCA(pratio=1-1e-4))
spca_mdl = SPCA()
spca = machine(spca_mdl, X)
fit!(spca)
W = transform(spca, X)
names(W)