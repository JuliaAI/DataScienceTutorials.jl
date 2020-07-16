<!--This file was generated, do not modify it.-->
This tutorial is loosely adapted from [this pandas tutorial](https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html) as well as the [DataFrames.jl documentation](http://juliadata.github.io/DataFrames.jl/latest/man/getting_started/).
It is by no means meant to be a complete introduction, rather, it focuses on some key functionalities that are particularly useful in a classical machine learning context.

## Basics

To start with, we will use the `Boston` dataset which is very simple.

```julia:ex1
using RDatasets
using DataFrames

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

### `combine`

The `combine` function allows to derive a new dataframe out of transformations of an existing one.
Here's an example taken from the official doc (see `?combine`):

```julia:ex24
df = DataFrame(a=1:3, b=4:6)
combine(df, :a => sum, nrow)
```

what happened here is that the derived DataFrame has two columns obtained respectively by (1) computing the sum of the first column and (2) applying the `nrow` function on the `df`.

The transformation can produce one or several values, `combine` will try to concatenate these columns as it can, for instance:

```julia:ex25
foo(v) = v[1:2]
combine(df, :a => maximum, :b => foo)
```

here the maximum value of `a` is copied twice so that the two columns have the same number of rows.

```julia:ex26
bar(v) = v[end-1:end]
combine(df, :a => foo, :b => bar)
```

### `combine` with `groupby`

Combining `groupby` with `combine` is very useful.
For instance you might want to compute statistics across groups for different variables:

```julia:ex27
combine(groupby(iris, :Species), :PetalLength => mean)
```

let's decompose that:

1. the `groupby(iris, :Species)` creates groups using the `:Species` column (which has values `setosa`, `versicolor`, `virginica`)
2. the `combine` creates a derived dataframe by applying the `mean` function to the `:PetalLength` column
3. since there are three groups, we get one column (mean of `PetalLength`) and three rows (one per group).


You can do this for several columns/statistics at the time and give new column names to the results:

```julia:ex28
gdf = groupby(iris, :Species)
combine(gdf, :PetalLength => mean => :MPL, :PetalLength => std => :SPL)
```

so here we assign the names `:MPL` and `:SPL` to the derived columns.
If you want to apply something on all columns apart from the grouping one, using `names` and `Not` comes in handy:

```julia:ex29
combine(gdf, names(iris, Not(:Species)) .=> std)
```

where

```julia:ex30
names(iris, Not(:Species))
```

and note the use of `.` in `.=>` to indicate that we broadcast the function over each column.

