# This file was generated, do not modify it. # hide
sort!(cap_sum_plot, :capacity_mw_sum, rev=true)

using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

Plots.bar(cap_sum_plot.country, cap_sum_plot.capacity_mw_sum, legend=false)

savefig(joinpath(@OUTPUT, "D0-processing-g1.svg")); # hide