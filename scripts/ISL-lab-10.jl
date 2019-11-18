# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

