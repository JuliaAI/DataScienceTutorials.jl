# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using CategoricalArrays

v = categorical(["AA", "BB", "CC", "AA", "BB", "CC"])

levels(v)

v = categorical([1, 2, 3, 1, 2, 3, 1, 2, 3], ordered=true)

levels(v)

v[1] < v[2]

v = categorical(["high", "med", "low", "high", "med", "low"], ordered=true)

levels(v)

v[1] < v[2]

levels!(v, ["low", "med", "high"])

v[1] < v[2]

v = categorical(["AA", "BB", missing, "AA", "BB", "CC"]);

levels(v)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

