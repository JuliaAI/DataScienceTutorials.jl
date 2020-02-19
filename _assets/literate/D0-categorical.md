<!--This file was generated, do not modify it.-->
This tutorial follows loosely [the docs](https://juliadata.github.io/CategoricalArrays.jl/latest/using.html).

## Defining a categorical vector

```julia:ex1
using CategoricalArrays

v = categorical(["AA", "BB", "CC", "AA", "BB", "CC"])
```

This declares a categorical vector, i.e. a Vector whose entries are expected to represent a group or category.
You can retrieve the group labels using `levels`:

```julia:ex2
levels(v)
```

which, by  default, returns the labels in lexicographic order.

## Working with categoricals

### Ordered categoricals

You can specify that categories are *ordered* by specifying `ordered=true`, the order then follows that of the levels. If you wish to change that order, you  need to  use the `levels!` function.
Let's see two examples.

```julia:ex3
v = categorical([1, 2, 3, 1, 2, 3, 1, 2, 3], ordered=true)

levels(v)
```

Here the lexicographic order matches what we want so no  need to change it, since we've specified  that the categories are ordered we can do:

```julia:ex4
v[1] < v[2]
```

Let's now consider another example

```julia:ex5
v = categorical(["high", "med", "low", "high", "med", "low"], ordered=true)

levels(v)
```

The levels follow the lexicographic order which  is not what  we want:

```julia:ex6
v[1] < v[2]
```

In order to re-specify the order we need to  use `levels!`:

```julia:ex7
levels!(v, ["low", "med", "high"])
```

now things are properly ordered:

```julia:ex8
v[1] < v[2]
```

### Missing values

You can also have a categorical vector with missing values:

```julia:ex9
v = categorical(["AA", "BB", missing, "AA", "BB", "CC"]);
```

that doesn't change the levels:

```julia:ex10
levels(v)
```

