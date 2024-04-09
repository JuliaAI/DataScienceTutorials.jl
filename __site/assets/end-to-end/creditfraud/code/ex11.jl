# This file was generated, do not modify it. # hide
data[!,:Amount] = log.(data[!,:Amount] .+ 1e-6);
histogram(data.Amount)

savefig(joinpath(@OUTPUT, "EX-creditfraud-amount.svg")); # hide