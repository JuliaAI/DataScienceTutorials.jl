<!--This file was generated, do not modify it.-->
````julia:ex1
using Pkg # hideall
Pkg.activate("_literate/data/categorical/Project.toml")
Pkg.instantiate()
````

This tutorial follows loosely [the docs](https://juliadata.github.io/CategoricalArrays.jl/latest/using.html).

@@dropdown
## Defining a categorical vector
@@
@@dropdown-content

````julia:ex2
using CategoricalArrays

v = categorical(["AA", "BB", "CC", "AA", "BB", "CC"])
````

This declares a categorical vector, i.e. a Vector whose entries are expected to represent a group or category.
You can retrieve the group labels using `levels`:

````julia:ex3
levels(v)
````

which, by  default, returns the labels in lexicographic order.

‎
@@
@@dropdown
## Working with categoricals
@@
@@dropdown-content

@@dropdown
### Ordered categoricals
@@
@@dropdown-content

You can specify that categories are *ordered* by specifying `ordered=true`, the order then follows that of the levels. If you wish to change that order, you  need to  use the `levels!` function.
Let's see two examples.

````julia:ex4
v = categorical([1, 2, 3, 1, 2, 3, 1, 2, 3], ordered=true)

levels(v)
````

Here the lexicographic order matches what we want so no  need to change it, since we've specified  that the categories are ordered we can do:

````julia:ex5
v[1] < v[2]
````

Let's now consider another example

````julia:ex6
v = categorical(["high", "med", "low", "high", "med", "low"], ordered=true)

levels(v)
````

The levels follow the lexicographic order which  is not what  we want:

````julia:ex7
v[1] < v[2]
````

In order to re-specify the order we need to  use `levels!`:

````julia:ex8
levels!(v, ["low", "med", "high"])
````

now things are properly ordered:

````julia:ex9
v[1] < v[2]
````

‎
@@
@@dropdown
### Missing values
@@
@@dropdown-content

You can also have a categorical vector with missing values:

````julia:ex10
v = categorical(["AA", "BB", missing, "AA", "BB", "CC"]);
````

that doesn't change the levels:

````julia:ex11
levels(v)
````

‎
@@

‎
@@

