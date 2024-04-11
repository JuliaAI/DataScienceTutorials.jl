# This file was generated, do not modify it. # hide
p1 = scatter(
	data.Solar_gen,
	data.Radiation_dir,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Solar radiation - directional",
)

p2 = scatter(
	data.Solar_gen,
	data.Radiation_dif,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Solar radiation - diffuse",
)

p3 = scatter(
	data.Solar_gen,
	data.Windspeed,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Wind speed (m/s)",
)

p4 = scatter(
	data.Solar_gen,
	data.Temperature,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Temperature (C)",
)

plot!(p1, p2, p3, p4, layout = (2, 2), size = (1000, 1000))

savefig(joinpath(@OUTPUT, "solar_scatter.png")); # hide