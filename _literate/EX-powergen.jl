# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/MLJTutorials/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("MLJTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```


# ## Initial data processing ##
# In this tutorial we are fitting solar and wind power generation output for Germany using weather data.
# We focus on the use of two estimators: linear and lasso. Let's load the required packages to get started.

using MLJ
using CSV
using PyPlot
using DataFrames
using Statistics

@load LinearRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

# The power generation and weather data come from two separate datasets. We downloaded both datasets from [Open Power networks](https://open-power-system-data.org/). The power generation data is available [here](https://data.open-power-system-data.org/time_series/) and the weather data is available [here](https://data.open-power-system-data.org/weather_data/)
# Note that the first row in both datasets contains headers; hence we don't need to provide any.
power_path = "/Users/GD/Documents/GitHub/DataScienceTutorialsData.jl/data/power_syst/DE_power_hourly.csv"
power = CSV.read(power_path)

weather_path = "/Users/GD/Documents/GitHub/DataScienceTutorialsData.jl/data/power_syst/DE_weather_data.csv"
weather = CSV.read(weather_path)

# We've loaded both datasets but only have a rough idea of what's in each of them. To get a more precise view of the columns they contain, let's use the function describe.

names(power)
names(weather)

# Let's first consider the columns of the power DataFrame. For the purpose of this tutorial we are only interested in actual wind and solar generation. So we select a subset of the power dataframe containing only :utc_timestamp, :DE_solar_generation_actual and :DE_wind_generation_actual
select!(power,[:utc_timestamp, :DE_solar_generation_actual, :DE_wind_generation_actual])

# Inspection of the names in the weather DataFrame shows that we have weather data at the regional level (38 NUTS-2 statistical regions), which consists of four different weather
# variables: _windspeed_10m, _temperature, _radiation_direct_horizontal, _radiation_diffuse_horizontal
# To match the structure of the power data, we need to aggregate at the country level. We do this by calculating the country-level average across all 38 regions, for each weather variable.
# This means we need to calculate an average across columns of the DataFrame that refer to the same weather variable. To do this we first filter columns based on weather variable name and create new dataframes.
wind = weather[:,filter(x -> occursin("windspeed", String(x)), names(weather))]
temp = weather[:,filter(x -> occursin("temperature", String(x)), names(weather))]
raddir = weather[:,filter(x -> occursin("radiation_direct", String(x)), names(weather))]
raddif = weather[:,filter(x -> occursin("radiation_diffuse", String(x)), names(weather))]

# Next, we create a new column in each DataFrame to store the country-level mean and calculate the mean.
# We use a nested loop. The lower level loop iterates over all rows of a given DataFrame, the higher-level loop iterates over all dataframes in the df Array.
df = [wind,temp,raddir,raddif]
col_mean = [:windspeed_mean, :temp_mean, :raddir_mean, :raddif_mean]

for t in 1:4
  df[t][!,col_mean[t]] = zeros(Float64,size(df[t][1]))
  for (i,row) in enumerate(eachrow(df[t]))
            df[t][i, col_mean[t]] = mean(row)
  end
end

# Now that we have all variables we need to conduct our analysis, let's gather them in a single DataFrame...
data = DataFrame(Timestamp=weather.utc_timestamp,
                Solar_gen=power.DE_solar_generation_actual,
                Wind_gen=power.DE_wind_generation_actual,
                Windspeed=wind.windspeed_mean,
                Temperature=temp.temp_mean,
                Radiation_dir=raddir.raddir_mean,
                Radiation_dif=raddif.raddif_mean)

# ...and have a look at their summary statistics
describe(data)
# schema(data)

# Note that the describe() function also provides you with information about missing values for each of the columns. Fortunately, there are none.

# To get a better understanding of our targets, let's plot their respective distributions.

plt.figure(figsize=(8,6))
plt.hist(data.Solar_gen, color = "blue", edgecolor = "white", bins=100,
         density=true, alpha=0.5)
plt.xlabel("Solar power generation (MW)", fontsize=14)
plt.ylabel("Frequency", fontsize=14)

# As one might expect, the sun doesn't always shine (and certainly not at night), hence there is a very high proportion of observations whose value is equal or close to 0.
# The distribution of wind power generation looks markedly different

plt.figure(figsize=(8,6))
plt.hist(data.Wind_gen, color = "blue", edgecolor = "white", bins=50,
         density=true, alpha=0.5)
plt.xlabel("Wind power generation (MW)", fontsize=14)
plt.ylabel("Frequency", fontsize=14)

# Finally, before fitting the estimators, we might want to gauge what to expect from them by looking at scatter plots. Let's look at solar power first.

fig = figure(figsize=(15,15))

subplot(221)
scatter(data.Solar_gen,data.Radiation_dir)
xlabel("Solar power (kW)")
ylabel("Solar radiation - directional")

subplot(222)
scatter(data.Solar_gen,data.Radiation_dif)
xlabel("Solar power (kW)")
ylabel("Solar radiation - diffuse")

subplot(223)
scatter(data.Solar_gen,data.Windspeed)
xlabel("Solar power (kW)")
ylabel("Wind speed (m/s)")

subplot(224)
scatter(data.Solar_gen,data.Temperature)
xlabel("Solar power (kW)")
ylabel("Temperature (C)")

# Note the 2x quotes are important!!

# Then at wind generation

fig = figure(figsize=(15,15))

subplot(221)
scatter(data.Wind_gen,data.Radiation_dir)
xlabel("Wind power (kW)")
ylabel("Solar radiation - directional")

subplot(222)
scatter(data.Wind_gen,data.Radiation_dif)
xlabel("Wind power (kW)")
ylabel("Solar radiation - diffuse")

subplot(223)
scatter(data.Wind_gen,data.Windspeed)
xlabel("Wind power (kW)")
ylabel("Wind speed (m/s)")

subplot(224)
scatter(data.Wind_gen,data.Temperature)
xlabel("Wind power (kW)")
ylabel("Temperature (C)")

# As expected, solar power generation shows a strong relationship to solar irradiance while wind power generation denotes a strong relationship to wind speed.

# ## Fitting models ##
y_wind = data[:Wind_gen]
y_sol = data[:Solar_gen]
X = data[:,[:Windspeed,:Temperature,:Radiation_dir,:Radiation_dif]]

train, test = partition(eachindex(y_sol), 0.7, shuffle=true, rng=5)

#Models (LinearRegression and LASSO)

linReg = machine(LinearRegressor(), X, y_sol)
Lasso = machine(LassoRegressor(), X, y_sol)

fit!(linReg, rows=train)
fit!(Lasso, rows=train)

#Performance
y_hat =  predict(linReg, rows=test)
rms(y[test],y_hat)
rms(y[test],y_hat)

plt.figure(figsize=(8,6))
plt.plot(y_hat, color = "blue", label = "Observed")
plt.plot(y[test], color = "red", label = "Predicted")
plt.xlabel("Time", fontsize=14)
plt.ylabel("Power generation", fontsize=14)
plt.xlim(0,100)
plt.legend()

res = y_hat .- y[test]

stem(res)
