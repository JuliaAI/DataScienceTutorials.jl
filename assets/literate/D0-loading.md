<!--This file was generated, do not modify it.-->
In this short tutorial we discuss two ways to easily load data in Julia:

1. loading a standard dataset via `RDatasets.jl`,
1. loading a local file with `CSV.jl`,

## Using RDatasets

The package [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl) provides access to most of the many datasets listed on [this page](http://vincentarelbundock.github.io/Rdatasets/datasets.html).
These are well known, standard datasets that can be used to get started with data processing and classical machine learning such as for instance `iris`, `crabs`, `Boston`, etc.

To load such a dataset, you will need to specify which R package it belongs to as well as its name; for instance `Boston` is part of `MASS`.

```julia:ex1
using RDatasets

boston = dataset("MASS", "Boston");
```

The fact that `Boston` is part of `MASS` is clearly indicated on the [list](http://vincentarelbundock.github.io/Rdatasets/datasets.html) linked to earlier.
While it can be a bit slow, loading a dataset via RDatasets is very simple and convenient as you don't have to  worry about setting the names of columns etc.

The `dataset` function returns a `DataFrame` object from the [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) package.

```julia:ex2
typeof(boston)
```

For a short introduction to DataFrame objects, see [this tutorial](/pub/data/dataframe.html).

## Using CSV

The package [CSV.jl](https://github.com/JuliaData/CSV.jl) offers a powerful way to read arbitrary CSV files efficiently.
In particular the `CSV.read` function allows to read a file and return a DataFrame.

### Basic usage

Let's say you have a file `scripts/data/foo.csv` with the content

```plaintext
col1,col2,col3,col4,col5,col6,col7,col8
,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true
,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false
,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true
```

You can read it with CSV using

```julia:ex3
using CSV
data = CSV.read("scripts/data/foo.csv")
```

The data is also returned as a dataframe

```julia:ex4
typeof(data)
```

Some of the useful arguments for `read` are:

* `header=` to specify whether there's a header, or which line the header is on or to specify a full header yourself,
* `skipto=` to specify how many rows to skip before starting to read the data,
* `limit=` to specify a maximum number of rows to parse,
* `missingstring=` to specify a string or vector of strings that should be parsed as missing values,
* `delim=','` a char or string to specify how columns are separated.

For more details see `?CSV.File`.

### Example 1

Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00504/), the content of which we saved in `scripts/data/qsar.csv`.
It doesn't have a header so we have to provide it ourselves.

```julia:ex5
header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read("scripts/data/qsar.csv", header=header)
first(data, 3)
```

### Example 2

Let's consider [this dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00423/), the content of which we saved in `scripts/data/hcc.txt`.
It does not have a header and missing values indicated by `?`.

```julia:ex6
data = CSV.read("scripts/data/hcc.txt", header=false, missingstring="?")
first(data[:, 1:5], 3)
```

