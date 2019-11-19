# This file was generated, do not modify it.

using MLJ, RDatasets, Random

data = dataset("datasets", "USArrests")
names(data)

describe(data, :mean, :std)

X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous)

@load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)

W = transform(pca, X);

schema(W).names

r = report(pca)
cumsum(r.principalvars ./ r.tvar)

