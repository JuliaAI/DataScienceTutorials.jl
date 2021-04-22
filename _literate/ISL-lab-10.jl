# ## Getting started

using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select, Not, describe
using Random
MLJ.color_off() # hide

data = dataset("datasets", "USArrests")
names(data)

# Let's have a look at the mean and standard deviation of each feature:

describe(data, :mean, :std)

# Let's extract the numerical component and coerce

X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous, :Assault=>Continuous);

# ## PCA pipeline
#
# PCA is usually best done after standardization but we won't do it here:

@load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)
PCA
W = MLJ.transform(pca, X);

# W is the PCA'd data; here we've used default settings for PCA and it has recovered 2 components:

schema(W).names

# Let's inspect the fit:

r = report(pca)
cumsum(r.principalvars ./ r.tvar)

# In the second line we look at the explained variance with 1 then 2 PCA features and it seems that with 2 we almost completely recover all of the variance.

# ## More interesting data...

# Instead of just playing with toy data, let's load the orange juice data and extract only the columns corresponding to price data:

data = dataset("ISLR", "OJ")

X = select(data, [:PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM,
                  :SalePriceCH, :PriceDiff, :PctDiscMM, :PctDiscCH]);

# ### PCA pipeline

Random.seed!(1515)

SPCA = @pipeline(Standardizer(),
                 PCA(pratio=1-1e-4))

spca = machine(SPCA, X)
fit!(spca)
W = MLJ.transform(spca, X)
names(W)

# What kind of variance can we explain?

rpca = collect(values(report(spca).report_given_machine))[2]
cs = cumsum(rpca.principalvars ./ rpca.tvar)

# Let's visualise this

using PyPlot
ioff() # hide

figure(figsize=(8,6))

PyPlot.bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

savefig(joinpath(@OUTPUT, "ISL-lab-10-g1.svg")) # hide

# \figalt{PCA explained variance}{ISL-lab-10-g1.svg}

# So 4 PCA features are enough to recover most of the variance.

# ### Clustering

Random.seed!(1515)

KMeans = @load KMeans pkg=Clustering
SPCA2 = @pipeline(Standardizer(),
                  PCA(),
                  KMeans(k=3))

spca2 = machine(SPCA2, X)
fit!(spca2)

assignments = collect(values(report(spca2).report_given_machine))[3].assignments
mask1 = assignments .== 1
mask2 = assignments .== 2
mask3 = assignments .== 3;

# Now we can  try visualising this

using PyPlot

figure(figsize=(8, 6))
for (m, c) in zip((mask1, mask2, mask3), ("red", "green", "blue"))
    plot(W[m, 1], W[m, 2], ls="none", marker=".", markersize=10, color=c)
end

xlabel("PCA-1", fontsize=13)
ylabel("PCA-2", fontsize=13)
legend(["Group 1", "Group 2", "Group 3"], fontsize=13)

savefig(joinpath(@OUTPUT, "ISL-lab-10-cluster.svg")) # hide

# \fig{ISL-lab-10-cluster.svg}
PyPlot.close_figs() # hide
