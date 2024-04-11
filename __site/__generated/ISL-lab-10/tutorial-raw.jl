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

pca_mdl = PCA(variance_ratio=1)
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
    PCA(variance_ratio=1-1e-4)
)

spca = machine(SPCA, X)
fit!(spca)
W = MLJ.transform(spca, X)
names(W)

rpca = report(spca).pca
cs = cumsum(rpca.principalvars ./ rpca.tvar)

using Plots

Plots.bar(1:length(cs), cs, legend=false, size=((800,600)), ylim=(0, 1.1))
xlabel!("Number of PCA features")
ylabel!("Ratio of explained variance")
plot!(1:length(cs), cs, color="red", marker="o", linewidth=3)

Random.seed!(1515)

KMeans = @load KMeans pkg=Clustering
SPCA2 = Pipeline(
    Standardizer(),
    PCA(),
    KMeans(k=3)
)

spca2 = machine(SPCA2, X)
fit!(spca2)


assignments = report(spca2).k_means.assignments
mask1 = assignments .== 1
mask2 = assignments .== 2
mask3 = assignments .== 3;

p = plot(size=(800,600))
legend_items = ["Group 1", "Group 2", "Group 3"]
for (i, (m, c)) in enumerate(zip((mask1, mask2, mask3), ("red", "green", "blue")))
    scatter!(p, W[m, 1], W[m, 2], color=c, label=legend_items[i])
end
plot(p)
xlabel!("PCA-1")
ylabel!("PCA-2")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
