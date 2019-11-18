# This file was generated, do not modify it.

using MLJ, RDatasets, Random

data = dataset("datasets", "USArrests")
names(data)

describe(data, :mean, :std)

@load PCA pkg=MultivariateStats

@pipeline StdPCA(std = Standardizer(),
                 pca = PCA())

spca_mdl = StdPCA()
spca = machine(spca_mdl, X)
fit!(spca)

W = transform(spca, X);

schema(W).names

r = report(spca).reports[1]
cumsum(r.principalvars ./ r.tvar)

using LinearAlgebra
rank(MLJ.matrix(X))

