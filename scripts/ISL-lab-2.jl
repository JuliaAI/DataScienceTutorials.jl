# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Basic commands## This is a very brief and rough primer if you're new to Julia and wondering how to do simpe things that are relevant for data analysis.## Defining a vector
x = [1, 3, 2, 5]
@show x
@show length(x)

# Operations between vectors
y = [4, 5, 6, 1]
z = x .+ y # elementwise operation

# Defining a matrix
X = [1  2; 3 4]

# You can also do that from a vector
X = reshape([1, 2, 3, 4], 2, 2)

# But you have to be careful that it fills the matrix by column; so if you want to get the same result as before let's just permute the dimensions
X = permutedims(reshape([1, 2, 3, 4], 2, 2))

# Function calls can be split with the `|>` operator so that the above can also be written
X = reshape([1,2,3,4], 2, 2) |> permutedims

# You don't have to do that of course but we will sometimes use it in these tutorials.## There's a wealth of functions available for simple math operations
x = 4
@show x^2
@show sqrt(x)

# Element wise operations on a collection can be done with the dot syntax:
sqrt.([4, 9, 16])

# The packages `Statistics` and `StatsBase` offer a number of useful function for stats:
using Statistics, StatsBase

# **Note**: if you don't have `StatsBase`, you can add it using `using Pkg; Pkg.add("StatsBase")`.# Right, let's now compute some simple statistics:
x = randn(1_000) # 500 points iid from a N(0, 1)
μ = mean(x)
σ = std(x)
@show (μ, σ)

# Indexing data starts at 1, use `:` to indicate the full range
X = [1 2; 3 4; 5 6]
@show X[1, 2]
@show X[:, 1]
@show X[1, :]
@show X[[1, 2], [1, 2]]

# `size` gives dimensions (nrows, ncolumns)
size(X)

# ## Loading data## There are many ways to load data in Julia, one convenient one is via the CSV package.
using CSV

# Many datasets are available via the `RDatasets` package
using RDatasets

# And finally the `DataFrames` package allows to manipulate data easily
using DataFrames

# Let's load some data from RDatasets (the full list of datasets is available [here](http://vincentarelbundock.github.io/Rdatasets/datasets.html))
auto = dataset("ISLR", "Auto")
first(auto, 3)

# The `describe` function allows to get an idea for the data:
describe(auto, :mean, :median, :std)

# To retrieve column names, you can use `names`:
names(auto)

# Accesssing columns can be done in different ways:
mpg = auto.MPG
mpg = auto[:, 1]
mpg = auto[:, :MPG]
mpg |> mean

# To get dimensions you can use `size` and `nrow` and `ncol`
@show size(auto)
@show nrow(auto)
@show ncol(auto)

# For more detailed tutorials on basic data wrangling in Julia, consider## * the [learn x in y](https://learnxinyminutes.com/docs/julia/) julia tutorial# * the [`DataFrames.jl` docs](http://juliadata.github.io/DataFrames.jl/latest/)# * the [`StatsBases.jl` docs](https://juliastats.org/StatsBase.jl/latest/)
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

