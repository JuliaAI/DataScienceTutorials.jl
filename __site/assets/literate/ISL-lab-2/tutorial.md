<!--This file was generated, do not modify it.-->
```julia:ex1
using Pkg # hideall
Pkg.activate("_literate/ISL-lab-2/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end
```

## Basic commands

This is a very brief and rough primer if you're new to Julia and wondering how to do simple things that are relevant for data analysis.

Defining a vector

```julia:ex2
x = [1, 3, 2, 5]
@show x
@show length(x)
```

Operations between vectors

```julia:ex3
y = [4, 5, 6, 1]
z = x .+ y # elementwise operation
```

Defining a matrix

```julia:ex4
X = [1  2; 3 4]
```

You can also do that from a vector

```julia:ex5
X = reshape([1, 2, 3, 4], 2, 2)
```

But you have to be careful that it fills the matrix by column; so if you want to get the same result as before, you will need to permute the dimensions

```julia:ex6
X = permutedims(reshape([1, 2, 3, 4], 2, 2))
```

Function calls can be split with the `|>` operator so that the above can also be written

```julia:ex7
X = reshape([1,2,3,4], 2, 2) |> permutedims
```

You don't have to do that of course but we will sometimes use it in these tutorials.

There's a wealth of functions available for simple math operations

```julia:ex8
x = 4
@show x^2
@show sqrt(x)
```

Element wise operations on a collection can be done with the dot syntax:

```julia:ex9
sqrt.([4, 9, 16])
```

The packages `Statistics` (from the standard library) and [`StatsBase`](https://github.com/JuliaStats/StatsBase.jl) offer a number of useful function for stats:

```julia:ex10
using Statistics, StatsBase
```

Note that if you don't have `StatsBase`, you can add it using `using Pkg; Pkg.add("StatsBase")`.
Right, let's now compute some simple statistics:

```julia:ex11
x = randn(1_000) # 1_000 points iid from a N(0, 1)
μ = mean(x)
σ = std(x)
@show (μ, σ)
```

Indexing data starts at 1, use `:` to indicate the full range

```julia:ex12
X = [1 2; 3 4; 5 6]
@show X[1, 2]
@show X[:, 1]
@show X[1, :]
@show X[[1, 2], [1, 2]]
```

`size` gives dimensions (nrows, ncolumns)

```julia:ex13
size(X)
```

## Loading data

There are many ways to load data in Julia, one convenient one is via the [`CSV`](https://github.com/JuliaData/CSV.jl) package.

```julia:ex14
using CSV
```

Many datasets are available via the [`RDatasets`](https://github.com/JuliaStats/RDatasets.jl) package

```julia:ex15
using RDatasets
```

And finally the [`DataFrames`](https://github.com/JuliaData/DataFrames.jl) package allows to manipulate data easily

```julia:ex16
using DataFrames
```

Let's load some data from RDatasets (the full list of datasets is available [here](http://vincentarelbundock.github.io/Rdatasets/datasets.html)).

```julia:ex17
auto = dataset("ISLR", "Auto")
first(auto, 3)
```

The `describe` function allows to get an idea for the data:

```julia:ex18
describe(auto, :mean, :median, :std)
```

To retrieve column names, you can use `names`:

```julia:ex19
names(auto)
```

Accesssing columns can be done in different ways:

```julia:ex20
mpg = auto.MPG
mpg = auto[:, 1]
mpg = auto[:, :MPG]
mpg |> mean
```

To get dimensions you can use `size` and `nrow` and `ncol`

```julia:ex21
@show size(auto)
@show nrow(auto)
@show ncol(auto)
```

For more detailed tutorials on basic data wrangling in Julia, consider

* the [learn x in y](https://learnxinyminutes.com/docs/julia/) julia tutorial
* the [`DataFrames.jl` docs](http://juliadata.github.io/DataFrames.jl/latest/)
* the [`StatsBases.jl` docs](https://juliastats.org/StatsBase.jl/latest/)

## Plotting data

There are multiple libraries that can be used to  plot things in Julia:

* [Plots.jl](https://github.com/JuliaPlots/Plots.jl) which supports multiple plotting backends,
* [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl) influenced by the grammar of graphics and `ggplot2`
* [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl) basically matplotlib
* [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl) and [PGFPlots](https://github.com/JuliaTeX/PGFPlots.jl) using the LaTeX package  pgfplots,
* [Makie](https://github.com/JuliaPlots/Makie.jl), [Gaston](https://github.com/mbaz/Gaston.jl), [Vega](https://github.com/queryverse/VegaLite.jl), ...

In these tutorials we use `PyPlot` but you could use another package of course.

```julia:ex22
using PyPlot
ioff() # hide

figure(figsize=(8,6))
plot(mpg)

savefig(joinpath(@OUTPUT, "ISL-lab-2-mpg.svg")) # hide
```

\figalt{Simple plot}{ISL-lab-2-mpg.svg}

```julia:ex23
PyPlot.close_figs() # hide
```

