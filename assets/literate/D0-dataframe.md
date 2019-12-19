<!--This file was generated, do not modify it.-->
## Basics

```julia:ex1
using RDatasets

boston = dataset("MASS", "Boston");
```

You can show the first few rows using `first` and specifying a number of rows:

```julia:ex2
first(boston, 4)
```

`StatsBase` offers a convenient `describe` function which you can use to quickly get an overview of the data:

```julia:ex3
using StatsBase
describe(boston, :min, :max, :mean, :median, :std)
```

So here we get a derived object with one row per feature and one column per required statistic.

