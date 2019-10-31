print("getting started...\r")
using Pkg
Pkg.activate(".")
using JuDoc
using MLJ
MLJ.color_off();
println(rpad("ready", 50))
