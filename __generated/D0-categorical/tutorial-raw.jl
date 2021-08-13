# Before running this, please make sure to activate and instantiate the
# environment with [this `Project.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-categorical/Project.toml) and
# [this `Manifest.toml`](https://raw.githubusercontent.com/juliaai/DataScienceTutorials.jl/gh-pages/__generated/D0-categorical/Manifest.toml).
# For instance, copy these files to a folder 'D0-categorical', `cd` to it and
#
# ```julia
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


Pkg.activate("_literate/D0-categorical/Project.toml")
Pkg.update()

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

