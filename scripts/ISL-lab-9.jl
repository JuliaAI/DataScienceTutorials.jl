# ## Getting started

using MLJ, RDatasets, PrettyPrinting, Random

# We start by generating a 2D cloud of points

Random.seed!(1001)
X = randn(20, 2)
y = vcat(-ones(10), ones(10))
