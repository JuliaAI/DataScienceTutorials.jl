# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using RDatasets, DataFrames

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

by(iris, :Species, :PetalLength => mean)

by(iris, :Species, MPL = :PetalLength => mean, SPL = :PetalLength => std)

DataFrames.aggregate(iris, :Species, std)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

