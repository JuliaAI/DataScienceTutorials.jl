# This file was generated, do not modify it. # hide
using Plots

Plots.bar(countmap(data.Class), legend=false,)
xlabel!("Classes")
ylabel!("Number of samples")
savefig(joinpath(@OUTPUT, "Target_class.svg")); # hide