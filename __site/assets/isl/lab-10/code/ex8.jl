# This file was generated, do not modify it. # hide
Random.seed!(1515)

SPCA = @pipeline(Standardizer(),
                 PCA(pratio=1-1e-4))

spca = machine(SPCA, X)
fit!(spca)
W = transform(spca, X)
names(W)