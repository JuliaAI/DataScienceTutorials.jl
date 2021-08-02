# This file was generated, do not modify it.

using MLJ, RDatasets, Random

data = dataset("datasets", "USArrests")
names(data)

describe(data, :mean, :std)

X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous);

@load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)

W = transform(pca, X);

schema(W).names

r = report(pca)
cumsum(r.principalvars ./ r.tvar)

data = dataset("ISLR", "OJ")

X = select(data, [:PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM,
                  :SalePriceCH, :PriceDiff, :PctDiscMM, :PctDiscCH]);

Random.seed!(1515)

@pipeline SPCA(std = Standardizer(),
               pca = PCA(pratio=1-1e-4))
spca_mdl = SPCA()
spca = machine(spca_mdl, X)
fit!(spca)
W = transform(spca, X)
names(W)

r  = report(spca).reports[1]
cs = cumsum(r.principalvars ./ r.tvar)

using PyPlot

figure(figsize=(8,6))

bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

savefig("assets/literate/ISL-lab-10-g1.svg") # hide

Random.seed!(1515)

@load KMeans
@pipeline SPCA2(std = Standardizer(),
                pca = PCA(),
                km = KMeans(k=3))

spca2_mdl = SPCA2()
spca2 = machine(spca2_mdl, X)
fit!(spca2)

assignments = report(spca2).reports[1].assignments
mask1 = assignments .== 1
mask2 = assignments .== 2
mask3 = assignments .== 3;

using PyPlot

figure(figsize=(8, 6))
for (m, c) in zip((mask1, mask2, mask3), ("red", "green", "blue"))
    plot(W[m, 1], W[m, 2], ls="none", marker=".", markersize=10, color=c)
end

xlabel("PCA-1", fontsize=13)
ylabel("PCA-2", fontsize=13)
legend(["Group 1", "Group 2", "Group 3"], fontsize=13)

savefig("assets/literate/ISL-lab-10-cluster.svg") # hide

