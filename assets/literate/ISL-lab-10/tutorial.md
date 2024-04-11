<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/ISL-lab-10/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;
````

@@dropdown
## Getting started
@@
@@dropdown-content

````julia:ex2
using MLJ
import RDatasets: dataset
import DataFrames: DataFrame, select, Not, describe
using Random
MLJ.color_off() # hide

data = dataset("datasets", "USArrests")
names(data)
````

Let's have a look at the mean and standard deviation of each feature:

````julia:ex3
describe(data, :mean, :std)
````

Let's extract the numerical component and coerce

````julia:ex4
X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous, :Assault=>Continuous);
````

‎
@@
@@dropdown
## PCA pipeline
@@
@@dropdown-content

PCA is usually best done after standardization but we won't do it here:

````julia:ex5
PCA = @load PCA pkg=MultivariateStats

pca_mdl = PCA(variance_ratio=1)
pca = machine(pca_mdl, X)
fit!(pca)
PCA
W = MLJ.transform(pca, X);
````

W is the PCA'd data; here we've used default settings for PCA and it has recovered 2 components:

````julia:ex6
schema(W).names
````

Let's inspect the fit:

````julia:ex7
r = report(pca)
cumsum(r.principalvars ./ r.tvar)
````

In the second line we look at the explained variance with 1 then 2 PCA features and it seems that with 2 we almost completely recover all of the variance.

‎
@@
@@dropdown
## More interesting data...
@@
@@dropdown-content

Instead of just playing with toy data, let's load the orange juice data and extract only the columns corresponding to price data:

````julia:ex8
data = dataset("ISLR", "OJ")

feature_names = [
    :PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM, :SalePriceCH,
    :PriceDiff, :PctDiscMM, :PctDiscCH
]

X = select(data, feature_names);
````

@@dropdown
### PCA pipeline
@@
@@dropdown-content

````julia:ex9
Random.seed!(1515)

SPCA = Pipeline(
    Standardizer(),
    PCA(variance_ratio=1-1e-4)
)

spca = machine(SPCA, X)
fit!(spca)
W = MLJ.transform(spca, X)
names(W)
````

What kind of variance can we explain?

````julia:ex10
rpca = report(spca).pca
cs = cumsum(rpca.principalvars ./ rpca.tvar)
````

Let's visualise this

````julia:ex11
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

Plots.bar(1:length(cs), cs, legend=false, size=((800,600)), ylim=(0, 1.1))
xlabel!("Number of PCA features")
ylabel!("Ratio of explained variance")
plot!(1:length(cs), cs, color="red", marker="o", linewidth=3)

savefig(joinpath(@OUTPUT, "ISL-lab-10-g1.svg")); # hide
````

\figalt{PCA explained variance}{ISL-lab-10-g1.svg}

So 4 PCA features are enough to recover most of the variance.

‎
@@
@@dropdown
### Clustering
@@
@@dropdown-content

````julia:ex12
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
````

Now we can  try visualising this

````julia:ex13
p = plot(size=(800,600))
legend_items = ["Group 1", "Group 2", "Group 3"]
for (i, (m, c)) in enumerate(zip((mask1, mask2, mask3), ("red", "green", "blue")))
    scatter!(p, W[m, 1], W[m, 2], color=c, label=legend_items[i])
end
plot(p)
xlabel!("PCA-1")
ylabel!("PCA-2")

savefig(joinpath(@OUTPUT, "ISL-lab-10-cluster.svg")); # hide
````

\fig{ISL-lab-10-cluster.svg}

‎
@@

‎
@@

