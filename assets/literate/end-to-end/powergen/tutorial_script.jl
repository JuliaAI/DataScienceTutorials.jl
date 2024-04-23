# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/end-to-end/powergen/Project.toml")
Pkg.instantiate()
macro OUTPUT()
	return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
using UrlDownload
import DataFrames: DataFrame, describe, names, select!
using Statistics

LinearRegressor = @load LinearRegressor pkg = MLJLinearModels

data_repo = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data"

url_power   = data_repo * "/power_syst/DE_power_hourly.csv"
url_weather = data_repo * "/power_syst/DE_weather_data.csv"

power = DataFrame(urldownload(url_power))
weather = DataFrame(urldownload(url_weather));

describe(power, :mean, :nmissing)

first(describe(weather, :mean, :nmissing), 20)

select!(power, [
	:utc_timestamp,
	:DE_solar_generation_actual,
	:DE_wind_generation_actual]);

colnames = names(weather)

filter_by_name(name, cols) =
	filter(cn -> occursin(name, String(cn)), cols)

wind   = weather[:, filter_by_name("windspeed", colnames)]
temp   = weather[:, filter_by_name("temperature", colnames)]
raddir = weather[:, filter_by_name("radiation_direct", colnames)]
raddif = weather[:, filter_by_name("radiation_diffuse", colnames)];

dfs = [wind, temp, raddir, raddif]
col_mean = [:windspeed_mean, :temp_mean, :raddir_mean, :raddif_mean];

n_rows = size(first(dfs), 1)
for (df, name) in zip(dfs, col_mean)
	df[!, name] = zeros(n_rows)
	for (i, row) in enumerate(eachrow(df))
		df[i, name] = mean(row)
	end
end;

data = DataFrame(
	Timestamp     = weather.utc_timestamp,
	Solar_gen     = power.DE_solar_generation_actual,
	Wind_gen      = power.DE_wind_generation_actual,
	Windspeed     = wind.windspeed_mean,
	Temperature   = temp.temp_mean,
	Radiation_dir = raddir.raddir_mean,
	Radiation_dif = raddif.raddif_mean);

describe(data, :mean, :median, :nmissing)

schema(data)

coerce!(data, :Wind_gen => Continuous)
coerce!(data, :Solar_gen => Continuous)

schema(data)

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.3) #hide

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

histogram(data.Wind_gen, color = "blue", bins = 50, normalize = :pdf, alpha = 0.5)
xlabel!("Wind power generation (MWh)")
ylabel!("Frequency")

savefig(joinpath(@OUTPUT, "hist_wind.svg")); # hide

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

p1 = scatter(
	data.Wind_gen,
	data.Radiation_dir,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Solar radiation - directional",
)

p2 = scatter(
	data.Wind_gen,
	data.Radiation_dif,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Solar radiation - diffuse",
)

p3 = scatter(
	data.Wind_gen,
	data.Windspeed,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Wind speed (m/s)",
)

p4 = scatter(
	data.Wind_gen,
	data.Temperature,
	size = (150, 150),
	legend = false,
	xlabel = "Solar power (kW)",
	ylabel = "Temperature (C)",
)

plot!(p1, p2, p3, p4, layout = (2, 2), size = (1000, 1000))


savefig(joinpath(@OUTPUT, "wind_scatter.png")); # hide

y_wind = data.Wind_gen
X = data[:, [:Windspeed, :Temperature, :Radiation_dir, :Radiation_dif]];

train, test = partition(collect(eachindex(y_wind)), 0.7, shuffle = true, rng = 5);

linReg = LinearRegressor()
m_linReg = machine(linReg, X, y_wind)
fit!(m_linReg, rows = train);

y_hat = MLJ.predict(m_linReg, rows = test);

plot(y_hat, color = "blue", label = "Predicted", xlim = (0, 100), xticks = [])
plot!(y_wind[test], color = "red", label = "Observed")
xlabel!("Time")
ylabel!("Power generation")

savefig(joinpath(@OUTPUT, "obs_v_pred.svg")); # hide

rms(y_wind[train], MLJ.predict(m_linReg, rows = train))

rms(y_wind[test], y_hat)

res = y_hat .- y_wind[test];

plot(res, line = :stem, marker = :circle, xlim = (0, length(res)))
hline!([0], color = "red", linewidth = 3)

savefig(joinpath(@OUTPUT, "residuals.png")); # hide

histogram(res, color = "blue", bins = 50, normalize = :pdf, alpha = 0.5, legend = false)

savefig(joinpath(@OUTPUT, "hist_residuals.svg")); # hide
