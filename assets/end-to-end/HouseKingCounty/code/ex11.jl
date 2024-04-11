# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.2) # hide

histogram(df.price, color = "blue", normalize=:pdf, bins=50, alpha=0.5, legend=false)
xlabel!("Price")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_price.svg")); # hide