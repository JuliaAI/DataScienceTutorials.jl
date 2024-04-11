# This file was generated, do not modify it. # hide
using Plots
Plots.scalefontsizes() # hide
Plots.scalefontsizes(1.3) # hide

histogram(
	data.Solar_gen,
	color = "blue",
	bins = 100,
	normalize = :pdf,
	alpha = 0.5,
	yticks = [0, 1e-3, 2e-3],
)
xlabel!("Solar power generation (MWh)")
ylabel!("Frequency")
savefig(joinpath(@OUTPUT, "hist_solar.svg")); # hide