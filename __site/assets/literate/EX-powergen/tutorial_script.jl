# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/EX-powergen/Project.toml")
Pkg.update()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

using MLJ
using UrlDownload
using PyPlot
ioff() # hide
import DataFrames: DataFrame, describe, names, select!
using Statistics

LinearRegressor = @load LinearRegressor pkg=MLJLinearModels

data_repo = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data"

url_power   = data_repo * "/power_syst/DE_power_hourly.csv"
url_weather = data_repo * "/power_syst/DE_weather_data.csv"

power   = DataFrame(urldownload(url_power))
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

figure(figsize=(8, 6))
hist(data.Solar_gen, color="blue", edgecolor="white", bins=100,
     density=true, alpha=0.5)
xlabel("Solar power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)
xticks(fontsize=12)
yticks([0, 1e-3, 2e-3], fontsize=12)
savefig(joinpath(@OUTPUT, "hist_solar.svg")) # hide

figure(figsize=(8, 6))
hist(data.Wind_gen, color="blue", edgecolor = "white", bins=50,
     density=true, alpha=0.5)
xlabel("Wind power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)

savefig(joinpath(@OUTPUT, "hist_wind.svg")) # hide

fig = figure(figsize=(15, 15))

subplot(221)
scatter(data.Solar_gen, data.Radiation_dir)
xlabel("Solar power (kW)", fontsize=14)
ylabel("Solar radiation - directional", fontsize=14)

subplot(222)
scatter(data.Solar_gen, data.Radiation_dif)
xlabel("Solar power (kW)", fontsize=14)
ylabel("Solar radiation - diffuse", fontsize=14)

subplot(223)
scatter(data.Solar_gen, data.Windspeed)
xlabel("Solar power (kW)", fontsize=14)
ylabel("Wind speed (m/s)", fontsize=14)

subplot(224)
scatter(data.Solar_gen, data.Temperature)
xlabel("Solar power (kW)", fontsize=14)
ylabel("Temperature (C)", fontsize=14)

savefig(joinpath(@OUTPUT, "solar_scatter.png"), bbox_inches="tight") # hide

fig = figure(figsize=(15, 15))

subplot(221)
scatter(data.Wind_gen, data.Radiation_dir)
xlabel("Wind power (kW)", fontsize=14)
ylabel("Solar radiation - directional", fontsize=14)

subplot(222)
scatter(data.Wind_gen, data.Radiation_dif)
xlabel("Wind power (kW)", fontsize=14)
ylabel("Solar radiation - diffuse", fontsize=14)

subplot(223)
scatter(data.Wind_gen, data.Windspeed)
xlabel("Wind power (kW)", fontsize=14)
ylabel("Wind speed (m/s)", fontsize=14)

subplot(224)
scatter(data.Wind_gen, data.Temperature)
xlabel("Wind power (kW)", fontsize=14)
ylabel("Temperature (C)", fontsize=14)

savefig(joinpath(@OUTPUT, "wind_scatter.png"), bbox_inches="tight") # hide

y_wind = data.Wind_gen
X = data[:, [:Windspeed, :Temperature, :Radiation_dir, :Radiation_dif]];

train, test = partition(collect(eachindex(y_wind)), 0.7, shuffle=true, rng=5);

linReg = LinearRegressor()
m_linReg = machine(linReg, X, y_wind)
fit!(m_linReg, rows=train);

y_hat = MLJ.predict(m_linReg, rows=test);

figure(figsize=(8, 6))
plot(y_hat, color="blue", label="Predicted")
plot(y_wind[test], color="red", label="Observed")
xlabel("Time", fontsize=14)
ylabel("Power generation", fontsize=14)
xticks([])
yticks(fontsize=12)
xlim(0, 100)
legend(fontsize=14)

savefig(joinpath(@OUTPUT, "obs_v_pred.svg")) # hide

rms(y_wind[train], MLJ.predict(m_linReg, rows=train))

rms(y_wind[test], y_hat)

res = y_hat .- y_wind[test];

figure(figsize=(12, 6))
stem(res)
xlim(0, length(res))

savefig(joinpath(@OUTPUT, "residuals.png")) # hide

figure(figsize=(8, 6))
hist(res, color="blue", edgecolor="white", bins=50,
     density=true, alpha=0.5)

savefig(joinpath(@OUTPUT, "hist_residuals.svg")) # hide

