<!--This file was generated, do not modify it.-->
This tutorial is loosely adapted from [this pandas tutorial](https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html) as well as the [DataFrames.jl documentation](http://juliadata.github.io/DataFrames.jl/latest/man/getting_started/).
It is by no means meant to be a complete introduction, rather, it focuses on some key functionalities that are particularly useful in a classical machine learning context.

## Basics

To start with, we will use the `Boston` dataset which is very simple.

```julia:ex1
using RDatasets, DataFrames

boston = dataset("MASS", "Boston");
```

The `dataset` function returns a `DataFrame` object:

```julia:ex2
typeof(boston)
```

### Accessing data

Intuitively a DataFrame is just a wrapper around a number of columns, each of which is a `Vector` of some type with a name"

```julia:ex3
names(boston)
```

You can view the first few rows using `first` and specifying a number of rows:

```julia:ex4
first(boston, 4)
```

You can access one of those columns easily using `.colname`, this returns a vector that you can access like any Julia vector:

```julia:ex5
boston.Crim[1:5]
```

You can also just access the dataframe as you would a big matrix:

```julia:ex6
boston[3, 5]
```

or specifying a range of rows/columns:

```julia:ex7
boston[1:5, [:Crim, :Zn]]
```

or, similarly,

```julia:ex8
boston[1:5, 1:2]
```

The `select` function is very convenient to get sub dataframes of interest:

```julia:ex9
b1 = select(boston, [:Crim, :Zn, :Indus])
first(b1, 2)
```

The `Not` syntax is  also very  useful:

```julia:ex10
b2 = select(boston, Not(:NOx))
first(b2, 2)
```

Finally, if you would like to drop columns, you can use `select!` which will mutate the dataframe in place:

```julia:ex11
select!(b1, Not(:Crim))
first(b1, 2)
```

### Describing the data

`StatsBase` offers a convenient `describe` function which you can use on a DataFrame to get an overview of the data:

```julia:ex12
using StatsBase
describe(boston, :min, :max, :mean, :median, :std)
```

You can pass a number of symbols to the `describe` function to indicate which statistics to compute for each feature:

* `mean`, `std`, `min`, `max`, `median`, `first`, `last` are all fairly self explanatory
* `q25`, `q75` are respectively for the 25th and 75th percentile,
* `eltype`, `nunique`, `nmissing` can also be used

You can also  pass your custom function with a pair `name => function` for instance:

```julia:ex13
foo(x) = sum(abs.(x)) / length(x)
d = describe(boston, :mean, :median, :foo => foo)
first(d, 3)
```

The `describe` function returns a derived object with one row per feature and one column per required statistic.

Further to `StatsBase`, `Statistics` offers a range of useful functions for data analysis.

```julia:ex14
using Statistics
```

### Converting the data

If you want to get the content of the dataframe as one big matrix, use `convert`:

```julia:ex15
mat = convert(Matrix, boston)
mat[1:3, 1:3]
```

### Adding columns

Adding a column to a dataframe is very easy:

```julia:ex16
boston.Crim_x_Zn = boston.Crim .* boston.Zn;
```

that's it! Remember also that you can drop columns or make subselections with `select` and `select!`.

### Missing values

Let's load a dataset with missing values

```julia:ex17
mao = dataset("gap", "mao")
describe(mao, :nmissing)
```

Lots of missing values...
If  you wanted to compute simple functions on columns, they  may just return `missing`:

```julia:ex18
std(mao.Age)
```

The `skipmissing` function can help counter this  easily:

```julia:ex19
std(skipmissing(mao.Age))
```

## Split-Apply-Combine

This is a shorter version of the [DataFrames.jl tutorial](http://juliadata.github.io/DataFrames.jl/latest/man/split_apply_combine/).

```julia:ex20
iris = dataset("datasets", "iris")
first(iris, 3)
```

### `groupby`

The `groupby` function allows to form "sub-dataframes" corresponding to groups of rows.
This can be very convenient to run specific analyses for specific groups without copying the data.

The basic usage is `groupby(df, cols)` where `cols` specifies one or several columns to use for the grouping.

Consider a simple example: in `iris` there is a `Species` column with 3 species:

```julia:ex21
unique(iris.Species)
```

We can form views for each of these:

```julia:ex22
gdf = groupby(iris, :Species);
```

The `gdf` object now corresponds to **views** of the original dataframe for each of the 3 species; the first species is `"setosa"` with:

```julia:ex23
subdf_setosa = gdf[1]
describe(subdf_setosa, :min, :mean, :max)
```

Note that `subdf_setosa` is a `SubDataFrame` meaning that it is just a view of the parent dataframe `iris`; if you modify that parent dataframe then the sub dataframe is also  modified.

See `?groupby` for more information.

### `by`

The `by` function allows you to compute statistics on given columns for each group.
Let's start with a very simple example:

```julia:ex24
by(iris, :Species, :PetalLength => mean)
```

So this returns the mean of the `:PetaLength` feature for each `:Species`.

You can do this for several columns/statistics at the time and give specific names to the results:

```julia:ex25
by(iris, :Species, MPL = :PetalLength => mean, SPL = :PetalLength => std)
```

See `?by` for more information.

### `aggregate`

The aggregate function is a bit like `by` except that it applies the given function on all columns:

```julia:ex26
DataFrames.aggregate(iris, :Species, std)
```

