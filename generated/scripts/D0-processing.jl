# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

# ## More data processing## This tutorial uses the World Resources Institute Global Power Plants Dataset to explore data pre-processing in Julia.# The dataset is created from multiple sources and is under continuous update, which means that there are lots of missing data, non-standard characters, etc# Hence plenty of material to work with!
# More tutorials on the manipulation of DataFrames can be found [here](https://github.com/bkamins/Julia-DataFrames-Tutorial)# And some more information can be found on [this](https://en.wikibooks.org/wiki/Introducing_Julia/DataFrames) wikipage.
import MLJ: schema, std, mean, median, coerce, coerce!, scitype
using DataFrames
using UrlDownload
using PyPlot


# Import data
raw_data = urldownload("https://github.com/tlienart/DataScienceTutorialsData.jl/blob/master/data/wri_global_power_plant_db_be_022020.csv?raw=true")
data = DataFrame(raw_data);

# This dataset contains information on power generation plants for a number of countries around the world.# The level of disaggregation is the power plant. For each plant, there is information about its name, localisation, capacity, and many other features.# The schema function enables us to get a quick overview of the variables it contains, including their machine and scentific types.
schema(data)

# We see that a small number of features have values for all plants (i.e. for each row) present in the dataset.# However, (i) several features have missing values (Union{Missing, _.type}) and (ii) we are not interested in working with all of these features.# In particular, we're not intersted in the source of the information present in the dataset nor are we interested in the generation data.# Hence we drop all columns which contain information's source.# We define a function `is_active()` that will return a `TRUE` boolean value if the column name does NOT (`!`) contain either of the strings "source" or "generation".# Note the conversion of column names from `:Symbol` to `:string` since the `occursing` function only accepts strings as arguments.
is_active(col) = !occursin(r"source|generation", string(col))
active_cols = [col for col in names(data) if is_active(col)]
select!(data, active_cols);

# We also drop a number of other unwanted columns and take a look at our "new" dataframe.
select!(data, Not([:wepp_id, :url, :owner]))
schema(data)

# The remaining variables have two different scientific types: Continuous, Textual# Of which we can get an overview.
describe(data)

# The describe() function shows that there are several features with missing values.

# *Note:* the `describe()` function is from the `DataFrames` package (and won't work with other, non DataFrames, tables) whereas the `schema()` is from the MLJ package.
# ---# Let's play around with capacity data, for which there are no missing values. We create a sub-dataframe and aggregate over certain dimensions (country and primary_fuel)
capacity = select(data, [:country, :primary_fuel, :capacity_mw]);
first(capacity, 5)

# This dataframe contains several subgroups (country and technology type) and it would be interesting to get data aggregates by subgroup.# To obtain a `view` of the DataFrame by subgroup, we can use the `groupby` function.# (See the [DataFrame tutorial](https://alan-turing-institute.github.io/DataScienceTutorials.jl/data/dataframe/#groupby) for an introduction to the use of `groupby`)
cap_gr = groupby(capacity, [:country, :primary_fuel]);

# If we want to aggregate at the country-fuel-type level and calculate summary statistics at this level, we can use the `combine` function on the GroupedDataFrame that we just created.# This function takes the GroupedDataFrame, the symbol of the column on which to apply the measure of choice as arguments.
cap_mean = combine(cap_gr, :capacity_mw => mean)
cap_sum = combine(cap_gr, :capacity_mw => sum)
first(cap_sum, 3)

# Now let's plot some of this aggregate data for a selection of countries, by country and technology type
ctry_selec = r"BEL|FRA|DEU"
tech_selec = r"Solar"

cap_sum_plot = cap_sum[occursin.(ctry_selec, cap_sum.country) .& occursin.(tech_selec, cap_sum.primary_fuel), :]

# Note the `.` for element-wise comparison# Before plotting, we can also sort values by decreasing order using `sort!()`.
sort!(cap_sum_plot, :capacity_mw_sum, rev=true)

figure(figsize=(8,6))

plt.bar(cap_sum_plot.country, cap_sum_plot.capacity_mw_sum, width=0.35)
plt.xticks(rotation=90)



# \figalt{processing1}{D0-processing-g1.svg}
# ---# Now that we have the total capacity by country and technology type, let's use it to calculate the share of each technology in total capacity.# To that end we first create a dataframe containing the country-level total capacity, using the same steps as above.
cap_sum_ctry_gd = groupby(capacity, [:country]);
cap_sum_ctry = combine(cap_sum_ctry_gd, :capacity_mw => sum);

# The we join this dataframe with the disaggregated one; which requires that we convert the two GroupedDataFrame into DataFrames.
cap_sum = DataFrame(cap_sum);
cap_sum_ctry = DataFrame(cap_sum_ctry);
cap_share = leftjoin(cap_sum, cap_sum_ctry, on = :country, makeunique = true)
cap_share.capacity_mw_share = cap_share.capacity_mw_sum ./ cap_share.capacity_mw_sum_1;

# Let's visualise our dataframe again, which now includes the `capacity_mw_share` column.
# ---# Now let's analyse features which exhibit some missing values.# Suppose we want to calculate the age of each plant (rounded to full years). We face two issues.# First, the commissioning_year is not reported for all plants.# We need to gauge the representativity of the plants for which it is available with regard to the full dataset.# One way to count the missing values is
nMissings = length(findall(x -> ismissing(x), data.commissioning_year))

# This represents about half of our observations
nMissings_share = nMissings/size(data)[1]

# Second, the commissioning year is not reported as an integer. Fractions of years are reported too.# As a result, the machine type of `data.commissioning_year`is Float64.
typeof(data.commissioning_year)

# Before calculating the average age, let's drop the missing values.
data_nmiss = dropmissing(data, :commissioning_year);

# And round the year to the closest integer. We can do this using the `round` function and a mapping function on the relevant DataFrame column.
map!(x -> round(x, digits=0), data_nmiss.commissioning_year, data_nmiss.commissioning_year);

# We can now calculate plant age for each plant (worth remembering that the dataset only contains active plants)

current_year = fill!(Array{Float64}(undef, size(data_nmiss)[1]), 2020);
data_nmiss[:, :plant_age] = current_year - data_nmiss[:, :commissioning_year];

# Since the commissioning year is missing for about half the plants in the dataset (17340, see description of data above) and that missing values propagate,# the plant age will only be available for 33643-17340 plants.# Let's see what the mean and median plant ages are across the plants for which we have the data
mean_age = mean(skipmissing(data_nmiss.plant_age))
median_age = median(skipmissing(data_nmiss.plant_age))

# And bring this into a frequency plot of the plant age observations
figure(figsize=(8,6))

plt.hist(data_nmiss.plant_age, color="blue", edgecolor="white", bins=100,
      density=true, alpha=0.5)
plt.axvline(mean_age, label = "Mean", color = "red")
plt.axvline(median_age, label = "Median")

plt.legend()

plt.xlim(0,)



# \figalt{processing2}{D0-processing-g2.svg}
# We can also calculate and plot average plant age by country and technology# Make sure all columns passed, other than the aggregation dimensions, are of type `Float` or `Int`, otherwise the function execution will fail.
age = select(data_nmiss, [:country, :primary_fuel, :plant_age])
age_mean = combine(groupby(age, [:country, :primary_fuel]), :plant_age => mean)

coal_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Coal", age_mean.primary_fuel), :]
gas_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Gas", age_mean.primary_fuel), :]

width = 0.35  # the width of the bars

fig, (ax1, ax2) = plt.subplots(1,2)

fig.suptitle("Mean plant age by country and technology")

ax1.bar(coal_means.country, coal_means.plant_age_mean, width, label="Coal")
ax2.bar(gas_means.country, gas_means.plant_age_mean, width, label="Gas")

ax1.set_ylabel("Age")

ax1.set_title("Coal")
ax2.set_title("Gas")



# \figalt{processing3}{D0-processing-g3.svg}
# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

