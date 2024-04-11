# This file was generated, do not modify it. # hide
histogram(res, color = "blue", bins = 50, normalize = :pdf, alpha = 0.5, legend = false)

savefig(joinpath(@OUTPUT, "hist_residuals.svg")); # hide