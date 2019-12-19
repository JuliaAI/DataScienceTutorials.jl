# In this tutorial we discuss three  ways to  get data in Julia:
#
# 1. loading a standard dataset via `RDatasets.jl`,
# 1. loading a local file with `CSV.jl`,
# 1. downloading and loading a file with `HTTP.jl` and `CSV.jl`
#
# ## Using RDatasets
#
# The package [RDatasets](https://github.com/JuliaStats/RDatasets.jl) provides access to most of the many datasets listed on [this page](http://vincentarelbundock.github.io/Rdatasets/datasets.html).
# These are well known, standard datasets that can be used to get started with data processing and classical machine learning such as for instance `iris`, `crabs`, `Boston`, etc.
#
# To load such a dataset, you will need to specify which R package it belongs to as well as its name; for instance `Boston` is part of `MASS`.

using RDatasets

boston = dataset("MASS", "Boston");

# The fact that `Boston` is part of `MASS` is clearly indicated on the [list](http://vincentarelbundock.github.io/Rdatasets/datasets.html) linked to earlier.
# While a bit slow, loading a dataset via RDatasets is very simple and convenient as you don't have to  worry about setting the names of columns etc.
#
# **Note**: not all datasets are available via `RDatasets.jl` but a large number of them are.
#
# The `dataset` function returns a `DataFrame` object from the [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) package.

typeof(boston)

# For a short introduction to DataFrame objects, see [this tutorial](/pub/data/dataframe.html).

# ## Using CSV
