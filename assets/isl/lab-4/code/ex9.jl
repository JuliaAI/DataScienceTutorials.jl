# This file was generated, do not modify it. # hide
cm = countmap(y)
categories, vals = collect(keys(cm)), collect(values(cm))
Plots.bar(categories, vals, title="Bar Chart Example", legend=false)
ylabel!("Number of occurrences")

savefig(joinpath(@OUTPUT, "ISL-lab-4-bal.svg")); # hide