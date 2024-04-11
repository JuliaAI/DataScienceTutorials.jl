# This file was generated, do not modify it. # hide
plot(res, line = :stem, marker = :circle, xlim = (0, length(res)))
hline!([0], color = "red", linewidth = 3)

savefig(joinpath(@OUTPUT, "residuals.png")); # hide