# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-loading/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-loading/Manifest.toml).
# For instance, copy these files to a folder 'D0-loading', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# In this short tutorial we discuss two ways to easily load data in Julia:
#
# 1. loading a standard dataset via `RDatasets.jl`,
# 1. loading a local file with `CSV.jl`,
#
# ## Using RDatasets
#
# The package [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl) provides access to most of the many datasets listed on [this page](http://vincentarelbundock.github.io/Rdatasets/datasets.html).
# These are well known, standard datasets that can be used to get started with data processing and classical machine learning such as for instance `iris`, `crabs`, `Boston`, etc.
#
# To load such a dataset, you will need to specify which R package it belongs to as well as its name; for instance `Boston` is part of `MASS`.

using RDatasets
import DataFrames

boston = dataset("MASS", "Boston");

# The fact that `Boston` is part of `MASS` is clearly indicated on the [list](http://vincentarelbundock.github.io/Rdatasets/datasets.html) linked to earlier.
# While it can be a bit slow, loading a dataset via RDatasets is very simple and convenient as you don't have to  worry about setting the names of columns etc.
#
# The `dataset` function returns a `DataFrame` object from the [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) package.

typeof(boston)

# For a short introduction to DataFrame objects, see [this tutorial](/data/dataframe).

# ## Using CSV
#
# The package [CSV.jl](https://github.com/JuliaData/CSV.jl) offers a powerful way to read arbitrary CSV files efficiently.
# In particular the `CSV.read` function allows to read a file and return a DataFrame.
#
# ### Basic usage
#
# Let's say you have a file `foo.csv` at some path `fpath=joinpath("data", "foo.csv")` with the content
#
# ```
# col1,col2,col3,col4,col5,col6,col7,col8
# ,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true
# ,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false
# ,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true
# ```

# You can read it with CSV using

using CSV
data = CSV.read(fpath, DataFrames.DataFrame)

# Note that we use this `joinpath` for compatibility with  our system but you could pass any valid path on your system for instance `CSV.read("path/to/file.csv")`.
# The data is also returned as a dataframe

typeof(data)

# Some of the useful arguments for `read` are:
#
# * `header=` to specify whether there's a header, or which line the header is on or to specify a full header yourself,
# * `skipto=` to specify how many rows to skip before starting to read the data,
# * `limit=` to specify a maximum number of rows to parse,
# * `missingstring=` to specify a string or vector of strings that should be parsed as missing values,
# * `delim=','` a char or string to specify how columns are separated.
#
# For more details see `?CSV.File`.
#
# ### Example 1
#
# Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00504/), the content of which we saved in a file at path `fpath`.

# It doesn't have a header so we have to provide it ourselves.

header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read(fpath, DataFrames.DataFrame, header=header)
first(data, 3)

# ### Example 2
#
# Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00423/), the content of which we saved at `fpath`.

# It does not have a header and missing values indicated by `?`.

data = CSV.read(fpath, DataFrames.DataFrame, header=false, missingstring="?")
first(data[:, 1:5], 3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

