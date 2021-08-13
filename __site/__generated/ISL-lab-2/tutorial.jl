# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-2/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/ISL-lab-2/Manifest.toml).
# For instance, copy these files to a folder 'ISL-lab-2', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Basic commands
#
# This is a very brief and rough primer if you're new to Julia and wondering how to do simple things that are relevant for data analysis.
#
# Defining a vector

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

# But you have to be careful that it fills the matrix by column; so if you want to get the same result as before, you will need to permute the dimensions

X = permutedims(reshape([1, 2, 3, 4], 2, 2))

# Function calls can be split with the `|>` operator so that the above can also be written

X = reshape([1,2,3,4], 2, 2) |> permutedims

# You don't have to do that of course but we will sometimes use it in these tutorials.
#
# There's a wealth of functions available for simple math operations

x = 4
@show x^2
@show sqrt(x)

# Element wise operations on a collection can be done with the dot syntax:

sqrt.([4, 9, 16])

# The packages `Statistics` (from the standard library) and [`StatsBase`](https://github.com/JuliaStats/StatsBase.jl) offer a number of useful function for stats:

using Statistics, StatsBase

# Note that if you don't have `StatsBase`, you can add it using `using Pkg; Pkg.add("StatsBase")`.
# Right, let's now compute some simple statistics:

x = randn(1_000) # 1_000 points iid from a N(0, 1)
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

# ## Loading data
#
# There are many ways to load data in Julia, one convenient one is via the [`CSV`](https://github.com/JuliaData/CSV.jl) package.

using CSV

# Many datasets are available via the [`RDatasets`](https://github.com/JuliaStats/RDatasets.jl) package

using RDatasets

# And finally the [`DataFrames`](https://github.com/JuliaData/DataFrames.jl) package allows to manipulate data easily

using DataFrames

# Let's load some data from RDatasets (the full list of datasets is available [here](http://vincentarelbundock.github.io/Rdatasets/datasets.html)).

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

# For more detailed tutorials on basic data wrangling in Julia, consider
#
# * the [learn x in y](https://learnxinyminutes.com/docs/julia/) julia tutorial
# * the [`DataFrames.jl` docs](http://juliadata.github.io/DataFrames.jl/latest/)
# * the [`StatsBases.jl` docs](https://juliastats.org/StatsBase.jl/latest/)
#
# ## Plotting data
#
# There are multiple libraries that can be used to  plot things in Julia:
#
# * [Plots.jl](https://github.com/JuliaPlots/Plots.jl) which supports multiple plotting backends,
# * [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl) influenced by the grammar of graphics and `ggplot2`
# * [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl) basically matplotlib
# * [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl) and [PGFPlots](https://github.com/JuliaTeX/PGFPlots.jl) using the LaTeX package  pgfplots,
# * [Makie](https://github.com/JuliaPlots/Makie.jl), [Gaston](https://github.com/mbaz/Gaston.jl), [Vega](https://github.com/queryverse/VegaLite.jl), ...
#
# In these tutorials we use `PyPlot` but you could use another package of course.

using PyPlot

figure(figsize=(8,6))
plot(mpg)

# \figalt{Simple plot}{ISL-lab-2-mpg.svg}

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

