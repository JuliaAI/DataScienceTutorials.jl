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

