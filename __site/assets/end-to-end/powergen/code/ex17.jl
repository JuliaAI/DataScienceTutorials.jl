# This file was generated, do not modify it. # hide
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