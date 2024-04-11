# This file was generated, do not modify it. # hide
Random.seed!(1515)

SPCA = Pipeline(
    Standardizer(),
    PCA(variance_ratio=1-1e-4)
)

spca = machine(SPCA, X)
fit!(spca)
W = MLJ.transform(spca, X)
names(W)