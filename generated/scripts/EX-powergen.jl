# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# **Main author**: [Geoffroy Dolphin](https://github.com/gd1989)## ## Initial data processing# In this tutorial we are fitting solar and wind power generation output for Germany using weather data.# We focus on the use of a simple linear estimator. Let's load the required packages to get started.
using MLJ
using UrlDownload
using PyPlot

import DataFrames: DataFrame, describe, names, select!
using Statistics

@load LinearRegressor pkg=MLJLinearModels

# The power generation and weather data come from two separate datasets.# We downloaded both datasets from [Open Power networks](https://open-power-system-data.org/).# The power generation data is available [here](https://data.open-power-system-data.org/time_series/) and the weather data is available [here](https://data.open-power-system-data.org/weather_data/).# Note that the first row in both datasets contains headers; hence we don't need to provide any.
data_repo = "https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data"

url_power   = data_repo * "/power_syst/DE_power_hourly.csv"
url_weather = data_repo * "/power_syst/DE_weather_data.csv"

power   = DataFrame(urldownload(url_power))
weather = DataFrame(urldownload(url_weather));

# We've loaded both datasets but only have a rough idea of what's in each of them.# Let's get a quick overview of the power dataset:
describe(power, :mean, :nmissing)

# and the weather dataset (we only show the first 20 rows as there's 150 features):
first(describe(weather, :mean, :nmissing), 20)

# Let's first consider the columns of the power DataFrame.# For the purpose of this tutorial we are only interested in actual wind and solar generation.# So we select a subset of the power dataframe containing only `:utc_timestamp, :DE_solar_generation_actual` and `:DE_wind_generation_actual`:
select!(power, [
    :utc_timestamp,
    :DE_solar_generation_actual,
    :DE_wind_generation_actual]);

# Inspection of the column names in the weather DataFrame shows that we have weather data at the regional level (38 NUTS-2 statistical regions), which consists of four different weather variables: `_windspeed_10m, _temperature, _radiation_direct_horizontal, _radiation_diffuse_horizontal`.# To match the structure of the power data, we need to aggregate at the country level.# We do this by calculating the country-level average across all 38 regions, for each weather variable.# This means we need to calculate an average across columns of the DataFrame that refer to the same weather variable.# To do this we define a simple function to filter columns based on weather variable name and create new dataframes.
colnames = names(weather)

filter_by_name(name, cols) =
    filter(cn -> occursin(name, String(cn)), cols)

wind   = weather[:, filter_by_name("windspeed", colnames)]
temp   = weather[:, filter_by_name("temperature", colnames)]
raddir = weather[:, filter_by_name("radiation_direct", colnames)]
raddif = weather[:, filter_by_name("radiation_diffuse", colnames)];

# Next, we create a new column in each DataFrame to store the country-level mean and calculate the mean.# We use a nested loop.# The lower level loop iterates over all rows of a given DataFrame, the higher-level loop iterates over all dataframes in the df Array.
dfs = [wind, temp, raddir, raddif]
col_mean = [:windspeed_mean, :temp_mean, :raddir_mean, :raddif_mean];

# the zip function associates elements of two objects in the same position with one another:
nrows = size(first(dfs), 1)
for (df, name) in zip(dfs, col_mean)
    df[!, name] = zeros(nrows)
    for (i, row) in enumerate(eachrow(df))
      df[i, name] = mean(row)
    end
end;

# Now that we have all variables we need to conduct our analysis, let's gather them in a single DataFrame...
data = DataFrame(
    Timestamp     = weather.utc_timestamp,
    Solar_gen     = power.DE_solar_generation_actual,
    Wind_gen      = power.DE_wind_generation_actual,
    Windspeed     = wind.windspeed_mean,
    Temperature   = temp.temp_mean,
    Radiation_dir = raddir.raddir_mean,
    Radiation_dif = raddif.raddif_mean);

# ...and have a look at their summary statistics
describe(data, :mean, :median, :nmissing)

# Note that the `describe()` function provides you with information about missing values for each of the columns.# Fortunately, there are none.## ### Adjusting the scientific types## Let's check the default scientific type that's currently associated with the data features:
schema(data)

# It is important that the scientific type of the variables corresponds to one of the types allowed for use with the models you are planning to use.# (For more guidance on this, see the [Scientific Type](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/scitype/) tutorial.# The scientific type of both `Wind_gen` and `Solar_gen` is currently `Count`. Let's coerce them to `Continuous`.
coerce!(data, :Wind_gen => Continuous)
coerce!(data, :Solar_gen => Continuous)

schema(data)

# We're now ready to go!
# ## Exploratory Data Analysis
# To get a better understanding of our targets, let's plot their respective distributions.
figure(figsize=(8, 6))
hist(data.Solar_gen, color="blue", edgecolor="white", bins=100,
     density=true, alpha=0.5)
xlabel("Solar power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)
xticks(fontsize=12)
yticks([0, 1e-3, 2e-3], fontsize=12)


# \figalt{Histogram of the solar power generated}{hist_solar.svg}
# As one might expect, the sun doesn't always shine (and certainly not at night), hence there is a very high proportion of observations whose value is equal or close to 0.# The distribution of wind power generation looks markedly different
figure(figsize=(8, 6))
hist(data.Wind_gen, color="blue", edgecolor = "white", bins=50,
     density=true, alpha=0.5)
xlabel("Wind power generation (MWh)", fontsize=14)
ylabel("Frequency", fontsize=14)



# \figalt{Histogram of the wind power generated}{hist_wind.svg}
# Finally, before fitting the estimator, we might want to gauge what to expect from them by looking at scatter plots.# Let's look at solar power first.
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



# @@img-wide \figalt{Solar power scatter plots}{solar_scatter.png} @@
# Then at wind generation
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



# @@img-wide \figalt{Wind power scatter plots}{wind_scatter.png} @@
# As expected, solar power generation shows a strong relationship to solar irradiance while wind power generation denotes a strong relationship to wind speed.## ## Models## Let's fit a linear regression to our data.# We focus on fitting the wind power generation but the same procedure could be applied for the solar power generation (a good exercise!).
y_wind = data.Wind_gen
X = data[:, [:Windspeed, :Temperature, :Radiation_dir, :Radiation_dif]];

# Next, we partition the data in training and test set; we choose the usual 70-30 split:
train, test = partition(eachindex(y_wind), 0.7, shuffle=true, rng=5);

# then we instantiate a model and fit it:
linReg = LinearRegressor()
m_linReg = machine(linReg, X, y_wind)
fit!(m_linReg, rows=train);

# ### Model evaluation## We've now fitted the model for wind power generation (`Wind_gen`).# Let's use it to predict values over the test set and investigate the performance:
y_hat = predict(m_linReg, rows=test);

# We can start by visualising the observed and predicted valzes of wind power generation.
figure(figsize=(8, 6))
plot(y_hat, color="blue", label="Predicted")
plot(y_wind[test], color="red", label="Observed")
xlabel("Time", fontsize=14)
ylabel("Power generation", fontsize=14)
xticks([])
yticks(fontsize=12)
xlim(0, 100)
legend(fontsize=14)



# \figalt{Observed vs Predicted}{obs_v_pred.svg}
# Let's look at the RMSE on the training and test sets.
rms(y_wind[train], predict(m_linReg, rows=train))

# on the test set...
rms(y_wind[test], y_hat)

# Finally, let's plot the residuals to see if there is any obvious remaining structure in them.
res = y_hat .- y_wind[test];

# Let's look at the stem plot of the residuals to check if there's any structure we might not have picked up:
figure(figsize=(12, 6))
stem(res)
xlim(0, length(res))



# @@img-wide \figalt{Residuals}{residuals.png} @@
# Nothing really stands out, the distribution also looks ok:
figure(figsize=(8, 6))
hist(res, color="blue", edgecolor="white", bins=50,
     density=true, alpha=0.5)



# \figalt{Histogram of the residuals}{hist_residuals.svg}
# We leave it at that for now, I hope you found this tutorial interesting.
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

