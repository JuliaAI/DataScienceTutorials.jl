# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-scitype/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-scitype/Manifest.toml).
# For instance, copy these files to a folder 'D0-scitype', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/D0-scitype/Project.toml")
Pkg.update()

using RDatasets
using ScientificTypes

boston = dataset("MASS", "Boston")
sch = schema(boston)

unique(boston.Chas)

boston2 = coerce(boston, :Chas => OrderedFactor);

eltype(boston2.Chas)

elscitype(boston2.Chas)

boston3 = coerce(boston, :Chas => OrderedFactor, :Rad => OrderedFactor);

feature = ["AA", "BB", "AA", "AA", "BB"]
elscitype(feature)

feature2 = coerce(feature, Multiclass)
elscitype(feature2)

data = select(boston, [:Rad, :Tax])
schema(data)

data2 = coerce(data, Count => Continuous)
schema(data2)

boston3 = coerce(boston, autotype(boston, :few_to_finite))
schema(boston3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

