# This file was generated, do not modify it. # hide
cm = countmap(purchase)
categories, vals = collect(keys(cm)), collect(values(cm))
bar(categories, vals, title="Bar Chart Example", legend=false)
ylabel!("Number of occurrences")

savefig(joinpath(@OUTPUT, "ISL-lab-4-bal2.svg")); # hide