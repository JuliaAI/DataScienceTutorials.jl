# This file was generated, do not modify it. # hide
roc = roc_curve(ŷ, y[validation])
plt = scatter(roc, legend=false)
plot!(plt, xlab="false positive rate", ylab="true positive rate")
plot!([0, 1], [0, 1], linewidth=2, linestyle=:dash, color=:black)

savefig(joinpath(@OUTPUT, "EX-telco-roc.svg")); # hide