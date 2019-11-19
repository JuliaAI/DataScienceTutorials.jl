# ## Getting started

using MLJ, RDatasets, Random

data = dataset("datasets", "USArrests")
names(data)

# Let's have a look at the mean and standard deviation of each feature:

describe(data, :mean, :std)

# Let's extract the numerical component and coerce

X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous)

# ## PCA pipeline
#
# PCA is usually best done after standardization but we won't do it here:

@load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)

W = transform(pca, X);

# W is the PCA'd data; here we've used default settings for PCA and it has recovered 2 components:

schema(W).names

# Let's inspect the fit:

r = report(pca)
cumsum(r.principalvars ./ r.tvar)

# In the second line we look at the explained variance with 1 then 2 PCA features and it seems that with 2 we almost completely recover all  of the variance.

# ## K-Means Clustering

# **ONGOING**
