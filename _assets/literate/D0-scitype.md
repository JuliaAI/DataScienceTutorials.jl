<!--This file was generated, do not modify it.-->
## Machine type vs Scientific Type

\note{while [ScientificTypes.jl](https://github.com/alan-turing-institute/ScientificTypes.jl) was developped as  part of the development of MLJ and is broadly used by it, it is fully independent of MLJ and can easily be used outside of it.}

### Why make a distinction?

When analysing data, it is important to distinguish between

* **how the data is encoded** (e.g. `Int`), and
* **how the data should be interpreted** (e.g. a class label, a count, ...)

How the data is encoded will be referred to  as the **machine type** whereas how the data should be interpreted  will  be referred to   as the **scientific type** (or `scitype`).

In some cases, this may be un-ambiguous, for instance if you have a vector of floating point values, this should usually be interpreted as a continuous feature (e.g.: weights, speeds, temperatures, ...).

In many other cases however, there may be ambiguities, we list a few examples below:

* A vector  of `Int` e.g. `[1, 2, ...]` which should be interpreted as categorical labels,
* A vector of `Int` e.g. `[1, 2,  ...]` which should be interpreted as count data,
* A vector of `String` e.g. `["High", "Low", "High", ...]` which should  be  interpreted as ordered categorical labels,
* A vector of `String` e.g. `["John", "Maria", ...]` which should not interpreted as informative data,
* A vector of floating points `[1.5,  1.5, -2.3, -2.3]` which should be interpreted as categorical data (e.g. the few possible values of some setting), etc.

### The Scientific Types

The package ScientificTypes defines specific types which can be used to indicate how a particular feature should be interpreted; in particular:


```plaintext
Found
├─ Known
│  ├─ Finite
│  │  ├─ Multiclass
│  │  └─ OrderedFactor
│  └─ Infinite
│     ├─ Continuous
│     └─ Count
└─ Unknown
```

### Default scitype

A scientific type *convention* indicates broadly how a scientific types are associated with machine types, these will form the "first guess". The default convention is the *mlj* one which, for instance, suggest as `Continuous` any feature with machine type `<:AbstractFloat`.

In short, if you have data, there is a default interpretation of that data which you can inspect with `schema`:

```julia:ex1
using RDatasets, ScientificTypes
boston = dataset("MASS", "Boston")
sch = schema(boston)
```

In this cases, most of the variables have a (machine) type `Float64` and their default  interpretation is `Continuous`.
There is also `:Chas`, `:Rad` and `:Tax` that have a (machine) type  `Int64` and their default interpretation is `Count`.

While the interpretation as `Continuous` is usually fine, the interpretation as `Count` needs a bit more attention.
For instance note that:

```julia:ex2
unique(boston.Chas)
```

so even  though it's got a machine type of `Int64` and consequently a default  interpretation of `Count`, it would be more appropriate to interpret it as an `OrderedFactor`.

### Changing the scitype

In order to re-specify the scitype(s) of  feature(s) in a dataset, you can  use the `coerce` function and  specify pairs of variable name and  scientific type:

```julia:ex3
boston2 = coerce(boston, :Chas => OrderedFactor);
```

the effect of this is to convert the `:Chas` column to an ordered categorical vector:

```julia:ex4
eltype(boston2.Chas)
```

corresponding to the `OrderedFactor` scitype:

```julia:ex5
elscitype(boston2.Chas)
```

You can also specify multiple pairs in one shot with `coerce`:

```julia:ex6
boston3 = coerce(boston, :Chas => OrderedFactor, :Rad => OrderedFactor);
```

### String and Unknown

If a feature in  your dataset has String elements, then the  default scitype is `Unknown`; you can either choose to  drop  such columns or to coerce them to categorical:

```julia:ex7
feature = ["AA", "BB", "AA", "AA", "BB"]
elscitype(feature)
```

which you can coerce:

```julia:ex8
feature2 = coerce(feature, Multiclass)
elscitype(feature2)
```

## Tips and tricks

### Type to Type coercion

In  some cases you will want to reinterpret all features currently interpreted as some scitype `S1` into some other scitype `S2`.
An example  is if some features are currently interpreted as `Count` because their original type was `Int` but you  want  to  consider all such as `Continuous`:

```julia:ex9
data = select(boston, [:Rad, :Tax])
schema(data)
```

let's coerce from `Count` to `Continuous`:

```julia:ex10
data2 = coerce(data, Count => Continuous)
schema(data2)
```

### Autotype

A last useful tool is `autotype` which allows you to specify *rules* to define the interpretation of features automatically.
You can code your own rules but there are three useful ones that are pre-coded:

* the `:few_to_finite` rule which checks how many unique entries are present in a vector and if there are "few" suggests a categorical type,
* the `:discrete_to_continuous` rule converts `Integer` or `Count` to `Continuous`
* the `:string_to_multiclass` which returns `Multiclass` for any string-like column.

For instance:

```julia:ex11
boston3 = coerce(boston, autotype(boston, :few_to_finite))
schema(boston3)
```

You can also specify multiple rules, see [the docs](https://alan-turing-institute.github.io/ScientificTypes.jl/stable/#Automatic-type-conversion-for-tabular-data-1) for more information.

