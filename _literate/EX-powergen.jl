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
using UrlDownload
using PyPlot
using DataFrames: DataFrame, describe, names, select!
using Statistics

@load LinearRegressor pkg=MLJLinearModels
@load LassoRegressor pkg=MLJLinearModels

# The power generation and weather data come from two separate datasets.
# We downloaded both datasets from [Open Power networks](https://open-power-system-data.org/).
# The power generation data is available [here](https://data.open-power-system-data.org/time_series/) and the weather data is available [here](https://data.open-power-system-data.org/weather_data/)
# Note that the first row in both datasets contains headers; hence we don't need to provide any.

power = DataFrame(urldownload("https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/power_syst/DE_power_hourly.csv"))
weather = DataFrame(urldownload("https://raw.githubusercontent.com/tlienart/DataScienceTutorialsData.jl/master/data/power_syst/DE_weather_data.csv"))

# We've loaded both datasets but only have a rough idea of what's in each of them. To get a more precise view of the columns they contain, let's use the function names.

@show names(power)
@show names(weather)

# Let's first consider the columns of the power DataFrame. For the purpose of this tutorial we are only interested in actual wind and solar generation. So we select a subset of the power dataframe containing only :utc_timestamp, :DE_solar_generation_actual and :DE_wind_generation_actual
select!(power,[:utc_timestamp, :DE_solar_generation_actual, :DE_wind_generation_actual])

# Inspection of the names in the weather DataFrame shows that we have weather data at the regional level (38 NUTS-2 statistical regions), which consists of four different weather
# variables: _windspeed_10m, _temperature, _radiation_direct_horizontal, _radiation_diffuse_horizontal
# To match the structure of the power data, we need to aggregate at the country level. We do this by calculating the country-level average across all 38 regions, for each weather variable.
# This means we need to calculate an average across columns of the DataFrame that refer to the same weather variable. To do this we first filter columns based on weather variable name and create new dataframes.
colnames = names(weather)

wind = weather[:,filter(x -> occursin("windspeed", String(x)), colnames)]
temp = weather[:,filter(x -> occursin("temperature", String(x)), colnames)]
raddir = weather[:,filter(x -> occursin("radiation_direct", String(x)), colnames)]
raddif = weather[:,filter(x -> occursin("radiation_diffuse", String(x)), colnames)]

# Next, we create a new column in each DataFrame to store the country-level mean and calculate the mean.
# We use a nested loop. The lower level loop iterates over all rows of a given DataFrame, the higher-level loop iterates over all dataframes in the df Array.
df = [wind,temp,raddir,raddif]
col_mean = [:windspeed_mean, :temp_mean, :raddir_mean, :raddif_mean]

nrows = size(first(df), 1)
for (df, name) in zip(df, col_mean) # the zip function associates elements of two objects in the same position with one another.
    df[!, name] = zeros(nrows)
    for (i, row) in enumerate(eachrow(df))
      df[i, name] = mean(row)
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

# Note that the describe() function provides you with information about missing values for each of the columns. Fortunately, there are none.
# However, it does not provide information about the scientific type of each column/variable. For that, let's use schema()

schema(data)

# It is important that the scientific type of the variables corresponds to one of the types allowed for use with the models you are planning to use.
# (For more guidance on this, see the [Scientific Type](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/scitype/) tutorial.
# The scientific type of both Wind_gen and Solar_gen is currently Count. Let's coerce them to Continuous.

coerce!(data, :Wind_gen => Continuous)
coerce!(data, :Solar_gen => Continuous)

# We're ready to go!

# ## Exploratory Data Analysis

# To get a better understanding of our targets, let's plot their respective distributions.

figure(figsize=(8,6))
plt.hist(data.Solar_gen, color = "blue", edgecolor = "white", bins=100,
         density=true, alpha=0.5)
plt.xlabel("Solar power generation (MWh)", fontsize=14)
plt.ylabel("Frequency", fontsize=14)

# As one might expect, the sun doesn't always shine (and certainly not at night), hence there is a very high proportion of observations whose value is equal or close to 0.
# The distribution of wind power generation looks markedly different

figure(figsize=(8,6))
plt.hist(data.Wind_gen, color = "blue", edgecolor = "white", bins=50,
         density=true, alpha=0.5)
plt.xlabel("Wind power generation (MWh)", fontsize=14)
plt.ylabel("Frequency", fontsize=14)

# Finally, before fitting the estimators, we might want to gauge what to expect from them by looking at scatter plots. Let's look at solar power first.
# (Note the importance of 2x quotes in figure titles and legend!)

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

# ## Models (LinearRegression and LASSO)

# Let's estimate a LinearRegression and LASSO estimators to our data.
# First, we split the DataFrame between targets and fetures.
# Remember that there are currently two targets in our DataFrame, Wind_gen and Solar_gen. The subsequent sections focus only the fiting of wind power generetion.

y_wind = data[:Wind_gen]
y_sol = data[:Solar_gen]
X = data[:,[:Windspeed,:Temperature,:Radiation_dir,:Radiation_dif]]

# Next, we partition the new frames into train and test set. In this case, we choose a 70-30 split, keeping 70% of the data in the train set.

train, test = partition(eachindex(y_wind), 0.7, shuffle=true, rng=5)

# ### Model tuning

linReg = LinearRegressor()
Lasso = LassoRegressor()

# Let's choose a range of value for our regularization parameter
r_lasso = range(Lasso, :lambda, lower = 1, upper = 10_000, scale = :log10)

# And instantiate a tuned LASSO model
tm_Lasso = TunedModel(model=Lasso, ranges = r, resampling = CV(nfolds=3), measure = rms)

# Now we wrap both models in a machine...
m_linReg = machine(linReg, X, y_wind)
m_Lasso = machine(tm_Lasso, X, y_wind)

# ...and fit them. (The use of ! stores the parameters in place. Hence m_linReg and m_Lasso are now machines that contain the estmiated paramters)
fit!(m_linReg, rows=train)
fit!(m_Lasso, rows=train)


# ### Model evaluation
# We've now fitted both models for wind power generation (Wind_gen).
# Let's use them to predict values over the test set and investigate their perfomance

y_hat =  predict(m_Lasso, rows=test)
y_hat_lin = predict(m_linReg, rows=test)

# We can start by visualising the observed and predicted values of wind power generation.

figure(figsize=(8,6))
plt.plot(y_hat, color = "blue", label = "Predicted - Lasso")
plt.plot(y_hat_lin, color = "green", label = "Predicted - linReg")
plt.plot(y_wind[test], color = "red", label = "Observed")
plt.xlabel("Time", fontsize=14)
plt.ylabel("Power generation", fontsize=14)
plt.xlim(0,100)
plt.legend()

# Graphically at least, there is little difference between the predictions of the linear regression and LASSO estimators.
# Let's look at their respective RMSE on the training and test sets.

#1. Since the linear regression estimator has minimizing the RMSE as its objective function, we expect its RMSE on the training set of to be lower than that of the LASSO estimator
@show rms(y_wind[train],predict(m_linReg, rows=train))
@show rms(y_wind[train],predict(m_Lasso, rows=train))

#2. On the test set, we might expect the LASSO estimator to perform better
@show rms(y_wind[test],y_hat_lin)
@show rms(y_wind[test],y_hat)

# However, se see that is not the case. Hence, using a LASSO estimator on our data is not necessarily our best shot.
# Yet, had we had a larger set of weather features, LASSO would most likely have been found to perform better.
# In particular, it would have allowed to select the most relevant features and regularize their estimated effect.

# 3. Finally, let's plot the residuals to see if there is any obvious remaining structure in them.

res_lin = y_hat_lin .- y_wind[test]
res = y_hat .- y_wind[test]

# Let's look at the stem plot of the residuals
figure(figsize=(8,6))
stem(res_lin)
xlim(0,length(res_lin))

# And the distribution.
figure(figsize=(8,6))
plt.hist(res_lin, color = "blue", label = "Predicted - Lasso")

# Nothing obivous here.

# We leave it at that for now. Note, however, that a few twists to the above lines would allow us to repeat the estimation procedure for the Solar_gen target variable. Try it.
