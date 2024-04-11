# This file was generated, do not modify it. # hide
res = ŷ .- y
plot(res, line=:stem, linewidth=1, marker=:circle, legend=false, size=((800,600)))
hline!([0], linewidth=2, color=:red)    # add a horizontal line at x=0
savefig(joinpath(@OUTPUT, "ISL-lab-3-res.svg")); # hide