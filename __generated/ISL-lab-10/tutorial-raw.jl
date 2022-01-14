using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select, Not, describe
using Random

data = dataset("datasets", "USArrests")
names(data)

describe(data, :mean, :std)

X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous, :Assault=>Continuous);

PCA = @load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)
PCA
W = MLJ.transform(pca, X);

schema(W).names

r = report(pca)
cumsum(r.principalvars ./ r.tvar)

data = dataset("ISLR", "OJ")

feature_names = [
    :PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM, :SalePriceCH,
    :PriceDiff, :PctDiscMM, :PctDiscCH
]

X = select(data, feature_names);

Random.seed!(1515)

SPCA = Pipeline(
    Standardizer(),
    PCA(pratio=1-1e-4)
)

spca = machine(SPCA, X)
fit!(spca)
W = MLJ.transform(spca, X)
names(W)

rpca = collect(values(report(spca).report_given_machine))[2]
cs = cumsum(rpca.principalvars ./ rpca.tvar)

using PyPlot

figure(figsize=(8,6))

PyPlot.bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

Random.seed!(1515)

KMeans = @load KMeans pkg=Clustering
SPCA2 = Pipeline(
    Standardizer(),
    PCA(),
    KMeans(k=3)
)

spca2 = machine(SPCA2, X)
fit!(spca2)

assignments = collect(values(report(spca2).report_given_machine))[3].assignments
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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

