# This file was generated, do not modify it.

using RDatasets
using DataFrames

boston = dataset("MASS", "Boston");

typeof(boston)

names(boston)

first(boston, 4)

boston.Crim[1:5]

boston[3, 5]

boston[1:5, [:Crim, :Zn]]

boston[1:5, 1:2]

b1 = select(boston, [:Crim, :Zn, :Indus])
first(b1, 2)

b2 = select(boston, Not(:NOx))
first(b2, 2)

select!(b1, Not(:Crim))
first(b1, 2)

using StatsBase
describe(boston, :min, :max, :mean, :median, :std)

foo(x) = sum(abs.(x)) / length(x)
d = describe(boston, :mean, :median, :foo => foo)
first(d, 3)

using Statistics

mat = convert(Matrix, boston)
mat[1:3, 1:3]

boston.Crim_x_Zn = boston.Crim .* boston.Zn;

mao = dataset("gap", "mao")
describe(mao, :nmissing)

std(mao.Age)

std(skipmissing(mao.Age))

iris = dataset("datasets", "iris")
first(iris, 3)

unique(iris.Species)

gdf = groupby(iris, :Species);

subdf_setosa = gdf[1]
describe(subdf_setosa, :min, :mean, :max)

df = DataFrame(a=1:3, b=4:6)
combine(df, :a => sum, nrow)

foo(v) = v[1:2]
combine(df, :a => maximum, :b => foo)

bar(v) = v[end-1:end]
combine(df, :a => foo, :b => bar)

combine(groupby(iris, :Species), :PetalLength => mean)

gdf = groupby(iris, :Species)
combine(gdf, :PetalLength => mean => :MPL, :PetalLength => std => :SPL)

combine(gdf, names(iris, Not(:Species)) .=> std)

names(iris, Not(:Species))

