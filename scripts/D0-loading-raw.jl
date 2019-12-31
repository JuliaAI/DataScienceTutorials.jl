# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using RDatasets

boston = dataset("MASS", "Boston");

typeof(boston)

using CSV
data = CSV.read(joinpath(@__DIR__, "data", "foo.csv"))

typeof(data)

header = ["CIC0", "SM1_Dz", "GATS1i",
          "NdsCH", "NdssC", "MLOGP", "LC50"]
data = CSV.read(joinpath(@__DIR__, "data", "qsar.csv"),
                header=header)
first(data, 3)

data = CSV.read(joinpath(@__DIR__, "data", "hcc.txt"),
                header=false, missingstring="?")
first(data[:, 1:5], 3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

