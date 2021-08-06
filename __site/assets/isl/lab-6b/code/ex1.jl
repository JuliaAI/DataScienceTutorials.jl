# This file was generated, do not modify it. # hide
using Pkg # hideall
Pkg.activate("_literate/ISL-lab-6b/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

# In this tutorial, we are exploring the application of Ridge and Lasso