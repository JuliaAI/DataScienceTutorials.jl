# This file was generated, do not modify it. # hide
using Pkg # hideall
Pkg.activate("_literate/A-ensembles-2/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;