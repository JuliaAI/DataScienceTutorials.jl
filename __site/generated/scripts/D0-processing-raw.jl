# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

import MLJ: schema, std, mean, median, coerce, coerce!, scitype
using DataFrames
using UrlDownload
using PyPlot


raw_data = urldownload("https://github.com/tlienart/DataScienceTutorialsData.jl/blob/master/data/wri_global_power_plant_db_be_022020.csv?raw=true")
data = DataFrame(raw_data);

schema(data)

is_active(col) = !occursin(r"source|generation", string(col))
active_cols = [col for col in names(data) if is_active(col)]
select!(data, active_cols);

select!(data, Not([:wepp_id, :url, :owner]))
schema(data)

describe(data)

# The describe() function shows that there are several features with missing values.

capacity = select(data, [:country, :primary_fuel, :capacity_mw]);
first(capacity, 5)

cap_gr = groupby(capacity, [:country, :primary_fuel]);

cap_mean = combine(cap_gr, :capacity_mw => mean)
cap_sum = combine(cap_gr, :capacity_mw => sum)
first(cap_sum, 3)

ctry_selec = r"BEL|FRA|DEU"
tech_selec = r"Solar"

cap_sum_plot = cap_sum[occursin.(ctry_selec, cap_sum.country) .& occursin.(tech_selec, cap_sum.primary_fuel), :]

sort!(cap_sum_plot, :capacity_mw_sum, rev=true)

figure(figsize=(8,6))

plt.bar(cap_sum_plot.country, cap_sum_plot.capacity_mw_sum, width=0.35)
plt.xticks(rotation=90)



cap_sum_ctry_gd = groupby(capacity, [:country]);
cap_sum_ctry = combine(cap_sum_ctry_gd, :capacity_mw => sum);

cap_sum = DataFrame(cap_sum);
cap_sum_ctry = DataFrame(cap_sum_ctry);
cap_share = leftjoin(cap_sum, cap_sum_ctry, on = :country, makeunique = true)
cap_share.capacity_mw_share = cap_share.capacity_mw_sum ./ cap_share.capacity_mw_sum_1;

nMissings = length(findall(x -> ismissing(x), data.commissioning_year))

nMissings_share = nMissings/size(data)[1]

typeof(data.commissioning_year)

data_nmiss = dropmissing(data, :commissioning_year);

map!(x -> round(x, digits=0), data_nmiss.commissioning_year, data_nmiss.commissioning_year);

# We can now calculate plant age for each plant (worth remembering that the dataset only contains active plants)

current_year = fill!(Array{Float64}(undef, size(data_nmiss)[1]), 2020);
data_nmiss[:, :plant_age] = current_year - data_nmiss[:, :commissioning_year];

mean_age = mean(skipmissing(data_nmiss.plant_age))
median_age = median(skipmissing(data_nmiss.plant_age))

figure(figsize=(8,6))

plt.hist(data_nmiss.plant_age, color="blue", edgecolor="white", bins=100,
      density=true, alpha=0.5)
plt.axvline(mean_age, label = "Mean", color = "red")
plt.axvline(median_age, label = "Median")

plt.legend()

plt.xlim(0,)



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



# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

