# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## Machine type vs Scientific Type## ### Why make a distinction?## When analysing data, it is important to distinguish between## * *how the data is encoded* (e.g. `Int`), and# * *how the data should be interpreted* (e.g. a class label, a count, ...)## How the data is encoded will be referred to  as the **machine type** whereas how the data should be interpreted  will  be referred to   as the **scientific type** (or `scitype`).## In some cases, this may be un-ambiguous, for instance if you have a vector of floating point values, this should usually be interpreted as a continuous feature (e.g.: weights, speeds, temperatures, ...).## In many other cases however, there may be ambiguities, we list a few examples below:## * A vector  of `Int` e.g. `[1, 2, ...]` which should be interpreted as categorical labels,# * A vector of `Int` e.g. `[1, 2,  ...]` which should be interpreted as count data,# * A vector of `String` e.g. `["High", "Low", "High", ...]` which should  be  interpreted as ordered categorical labels,# * A vector of `String` e.g. `["John", "Maria", ...]` which should not interpreted as informative data,# * A vector of floating points `[1.5,  1.5, -2.3, -2.3]` which should be interpreted as categorical data (e.g. the few possible values of some setting), etc.## ### The Scientific Types## The package [ScientificTypes.jl](https://github.com/alan-turing-institute/ScientificTypes.jl) defines a barebone type hierarchy which can be used to indicate how a particular feature should be interpreted; in particular:## ```plaintext# Found# ├─ Known# │  ├─ Textual# │  ├─ Finite# │  │  ├─ Multiclass# │  │  └─ OrderedFactor# │  └─ Infinite# │     ├─ Continuous# │     └─ Count# └─ Unknown# ```## A *scientific type convention* is a specific implementation indicating how machine types can be related to scientific types. It may also provide helper functions to convert data to a given scitype.## The convention used in MLJ is implemented in [MLJScientificTypes.jl](https://github.com/alan-turing-institute/MLJScientificTypes.jl).# This is what we will use throughout; you never need to use ScientificTypes.jl# unless you intend to implement your own scientific type convention.## ### Inspecting the scitype## The `schema` function
using RDatasets
using MLJScientificTypes

boston = dataset("MASS", "Boston")
sch = schema(boston)

# In this cases, most of the variables have a (machine) type `Float64` and# their default  interpretation is `Continuous`.# There is also `:Chas`, `:Rad` and `:Tax` that have a (machine) type  `Int64`# and their default interpretation is `Count`.## While the interpretation as `Continuous` is usually fine, the interpretation# as `Count` needs a bit more attention.# For instance note that:
unique(boston.Chas)

# so even  though it's got a machine type of `Int64` and consequently a# default  interpretation of `Count`, it would be more appropriate to interpret# it as an `OrderedFactor`.## ### Changing the scitype## In order to re-specify the scitype(s) of  feature(s) in a dataset, you can# use the `coerce` function and  specify pairs of variable name and  scientific# type:
boston2 = coerce(boston, :Chas => OrderedFactor);

# the effect of this is to convert the `:Chas` column to an ordered categorical# vector:
eltype(boston2.Chas)

# corresponding to the `OrderedFactor` scitype:
elscitype(boston2.Chas)

# You can also specify multiple pairs in one shot with `coerce`:
boston3 = coerce(boston, :Chas => OrderedFactor, :Rad => OrderedFactor);

# ### String and Unknown## If a feature in  your dataset has String elements, then the  default scitype# is `Textual`; you can either choose to  drop  such columns or to coerce them# to categorical:
feature = ["AA", "BB", "AA", "AA", "BB"]
elscitype(feature)

# which you can coerce:
feature2 = coerce(feature, Multiclass)
elscitype(feature2)

# ## Tips and tricks## ### Type to Type coercion## In  some cases you will want to reinterpret all features currently# interpreted as some scitype `S1` into some other scitype `S2`.# An example  is if some features are currently interpreted as `Count` because# their original type was `Int` but you  want  to  consider all such as# `Continuous`:
data = select(boston, [:Rad, :Tax])
schema(data)

# let's coerce from `Count` to `Continuous`:
data2 = coerce(data, Count => Continuous)
schema(data2)

# ### Autotype## A last useful tool is `autotype` which allows you to specify *rules* to# define the interpretation of features automatically.# You can code your own rules but there are three useful ones that are pre-# coded:## * the `:few_to_finite` rule which checks how many unique entries are present# in a vector and if there are "few" suggests a categorical type,# * the `:discrete_to_continuous` rule converts `Integer` or `Count` to# `Continuous`# * the `:string_to_multiclass` which returns `Multiclass` for any string-like# column.## For instance:
boston3 = coerce(boston, autotype(boston, :few_to_finite))
schema(boston3)

# You can also specify multiple rules, see [the docs](https://alan-turing-institute.github.io/MLJScientificTypes.jl/stable/#Automatic-type-conversion-for-tabular-data-1) for more information.
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

