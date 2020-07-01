# # This tutoral uses the World Resources Institute Global Power Plants Dataset to explore data pre-processing in Julia.
# The dataset is created from multiple sources and is under continuous update, which means that there are lots of missing data, non-standard characters, etc
# Hence plenty of material to work with!

# More tutorials on the manipulation of DataFrames can be found [here](https://github.com/bkamins/Julia-DataFrames-Tutorial)
# And some more information can be found on [this](https://en.wikibooks.org/wiki/Introducing_Julia/DataFrames) wikipage.

import MLJ: schema, std, mean, median, coerce, coerce!, scitype
using DataFrames
using UrlDownload
using PyPlot

# Import data

raw_data = urldownload("https://github.com/tlienart/DataScienceTutorialsData.jl/blob/master/data/wri_global_power_plant_db_be_022020.csv?raw=true")
data = DataFrame(raw_data);

# This dataset contains information on power generation plants for a number of countries around the world.
# The level of disaggregation is the power plant. For each plant, there is information about its name, localisation, capacity, and many other features.
# The schema function enables us to get a quick overview of the variables it contains, including their machine and scentific types.

schema(data)

# We see that a small number of features have values for all plants (i.e. for each row) present in the dataset.
# However, (i) several features have missing values (Union{Missing, _.type}) and (ii) we are not interested in working with all of these features.
# In particular, we're not intersted in the source of the information present in the dataset nor are we interested in the generation data.
# Hence we drop all columns which contain information's source. Since these columns contain the string "source" and "generation" in their name, we can drop them from the dataframe by using a filter.

is_active(col) = !contains(col, r"source|generation")
active_cols = [col for col in names(data) if is_active(col)]
select!(data, active_cols);

# We also drop a number of other unwanted columns

select!(data, Not([:wepp_id, :url, :owner]))
schema(data)

# Finally, we are left with a DataFrame containing a number of variables with two different scientific types: Continuous, Textual
# Of which we can get an overview. *Note:* the `describe()` function is from the [Julia Base] whereas the `schema()` is from the MLJ package.

describe(data)

# The describe() function shows that there are several features with missing values.

###
# As a first (easy) step, let's play around with capacity data, for which there are no missing values. We create a sub-dataframe and aggregate over certain dimensions (country and primary_fuel)
capacity = select(data, [:country, :primary_fuel, :capacity_mw])
first(capacity, 5)

# To obtain a `view` of the DataFrame by subgroup, we can use the `groupby` function.
# (See the [DataFrame tutorial](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/dataframe/#groupby) for an introduction to the use of `groupby`)
cap_agg = groupby(capacity, [:country, :primary_fuel]);

# If we want to aggregate at the country-fuel type level and calculate summary statistics at this level, we can use the `aggregate` function.
# This function takes the DataFrame, the symbols of aggregation keys and the measure of choice as arguments.

cap_mean = DataFrames.aggregate(capacity, [:country, :primary_fuel], mean)
cap_sum = DataFrames.aggregate(capacity, [:country, :primary_fuel], sum)
first(cap_sum, 3)
#
# # Note that this function also accepts a GroupedDataFrame instead of a specification of the dataframe and the symbols of aggregation keys.
# DataFrames.aggregate(cap_agg, mean)
#
# ctry_selec = ["AFG"]
#
# selec_con = (cap_sum[!, :country] .== ctry_selec) .& (cap_sum[!, :primary_fuel] .== "Solar")
#
# # Note the `.` for element-wise comparison
#
# # To select matching rows , use the function `filter`.
# # filter()cap_sum[cap_sum[!, :country] .== ctry_selec, :]
#
# selec = cap_sum[selec_con, :]
# # select = weather[filter(x -> occursin(["AFG"], String(x)), ), :]
#
# # Plot aggregate capacity data, by country and technology, for selected countries
# figure(figsize=(8,6))
#
# plt.bar(selec.country, selec.capacity_mw_sum, width=0.35)
# plt.xticks(rotation=90)
#
#
# ###
# # Calculate shares of installed capacity (as share of total installed capacity in DB)
#
#
#
# ###
# # Now let's analyse features which exhibit some missing values.
# # Suppose we want to calculate the age of each plant (rounded to full years). We face two issues.
# # First, the commissioning_year is not reported for all plants.
# # We need to gauge the representativity of the plants for which it is available with regard to the full dataset.
# # One way to count the missing values is
# nMissings = length(findall(x -> ismissing(x), data.commissioning_year))
#
# # This represents about half of our observations
# nMissings_share = nMissings/size(data)[1]
#
# # Second, the commissioning year is not reported as an integer. Fractions of years are reported too.
# # As a result, the machine type of `data.commissioning_year`is Float64.
#
# typeof(data.commissioning_year)
#
# # Before calculating the average age, let's drop the missing values.
#
# data_nmiss = dropmissing(data, :commissioning_year)
#
# # And round the year to the closest integer. We can do this using the `round` function and a mapping function on the relevant DataFrame column.
#
# map!(x -> round(x, digits=0), data_nmiss.commissioning_year, data_nmiss.commissioning_year)
#
# # We can now calculate plant age for each plant (worth remembering that the dataset only contains active plants)
#
# current_year = fill!(Array{Float64}(undef, size(data_nmiss)[1]), 2020)
# data_nmiss[:, :plant_age] = current_year - data_nmiss[:, :commissioning_year]
#
# # Since the commissioning year is missing for about half the plants in the dataset (17340, see description of data above) and that missing values propagate,
# # the plant age will only be available for 33643-17340 plants.
#
# mean_age = mean(skipmissing(data_nmiss.plant_age))
# median_age = median(skipmissing(data_nmiss.plant_age))
#
# # Plot the distribution of plant age - we need to drop missing values from dataframe
# figure(figsize=(8,6))
#
# plt.hist(dropmissing(data_nmiss, :plant_age).plant_age, color="blue", edgecolor="white", bins=100,
#      density=true, alpha=0.5)
# plt.axvline(mean_age)
# plt.axvline(median_age)
#
# plt.xlim(0,)
#
# # Then calculate average plant age, by country and technology
#
# age = select(data_nmiss, [:country, :primary_fuel, :plant_age])
# age_mean = aggregate(age, [:country, :primary_fuel], mean)
#
# # Make sure all columns passed, other than the aggregation dimensions, are of type `Float` or `Int`, otherwise the function execution will fail.
#
# figure(figsize=(8,6))
#
# plt.hist(dropmissing(age_mean, :plant_age_mean).plant_age_mean, color="blue", edgecolor="white", bins=100,
#      density=true, alpha=0.5)
#
# plt.xlim(0,)
#
# # Aside from the programming tricks, we also learn that [technology x] is younger than [technology y].
#
# ###
# # #Data encoding
# # Suppose now that for the purpose of later analysis we need to encode the country labels.
# # An easy way to do this is to use the function `coerce`. Let's revert to the original dataset.
#
# test = coerce(data, autotype(data, :string_to_multiclass))
#
# ## It is also possible to resort to "OneHotEncoding" using the `Flux` package. This is not dealt with here
