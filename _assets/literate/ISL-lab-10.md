<!--This file was generated, do not modify it.-->
## Getting started

```julia:ex1
using MLJ, RDatasets, Random

data = dataset("datasets", "USArrests")
names(data)
```

Let's have a look at the mean and standard deviation of each feature:

```julia:ex2
describe(data, :mean, :std)
```

Let's extract the numerical component and coerce

```julia:ex3
X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous);
```

## PCA pipeline

PCA is usually best done after standardization but we won't do it here:

```julia:ex4
@load PCA pkg=MultivariateStats

pca_mdl = PCA(pratio=1)
pca = machine(pca_mdl, X)
fit!(pca)

W = transform(pca, X);
```

W is the PCA'd data; here we've used default settings for PCA and it has recovered 2 components:

```julia:ex5
schema(W).names
```

Let's inspect the fit:

```julia:ex6
r = report(pca)
cumsum(r.principalvars ./ r.tvar)
```

In the second line we look at the explained variance with 1 then 2 PCA features and it seems that with 2 we almost completely recover all of the variance.

## More interesting data...

Instead of just playing with toy data, let's load the orange juice data and extract only the columns corresponding to price data:

```julia:ex7
data = dataset("ISLR", "OJ")

X = select(data, [:PriceCH, :PriceMM, :DiscCH, :DiscMM, :SalePriceMM,
                  :SalePriceCH, :PriceDiff, :PctDiscMM, :PctDiscCH]);
```

### PCA pipeline

```julia:ex8
Random.seed!(1515)

@pipeline SPCA(std = Standardizer(),
               pca = PCA(pratio=1-1e-4))
spca_mdl = SPCA()
spca = machine(spca_mdl, X)
fit!(spca)
W = transform(spca, X)
names(W)
```

What kind of variance can we explain?

```julia:ex9
r  = report(spca).reports[1]
cs = cumsum(r.principalvars ./ r.tvar)
```

Let's visualise this

```julia:ex10
using PyPlot

figure(figsize=(8,6))

bar(1:length(cs), cs)
plot(1:length(cs), cs, color="red", marker="o")

xlabel("Number of PCA features", fontsize=14)
ylabel("Ratio of explained variance", fontsize=14)

savefig("assets/literate/ISL-lab-10-g1.svg") # hide
```

![PCA explained variance](/assets/literate/ISL-lab-10-g1.svg)

So 4 PCA features are enough to recover most of the variance.

### Clustering

```julia:ex11
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
```

Now we can  try visualising this

```julia:ex12
using PyPlot

figure(figsize=(8, 6))
for (m, c) in zip((mask1, mask2, mask3), ("red", "green", "blue"))
    plot(W[m, 1], W[m, 2], ls="none", marker=".", markersize=10, color=c)
end

xlabel("PCA-1", fontsize=13)
ylabel("PCA-2", fontsize=13)
legend(["Group 1", "Group 2", "Group 3"], fontsize=13)

savefig("assets/literate/ISL-lab-10-cluster.svg") # hide
```

![](/assets/literate/ISL-lab-10-cluster.svg)

