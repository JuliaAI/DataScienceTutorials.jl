# This file was generated, do not modify it.

using Pkg # hideall
Pkg.activate("_literate/D0-processing/Project.toml")
Pkg.instantiate()
macro OUTPUT()
    return isdefined(Main, :Franklin) ? Franklin.OUT_PATH[] : "/tmp/"
end;

import MLJ: schema, std, mean, median, coerce, coerce!, scitype
using DataFrames
using UrlDownload

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

using Plots
Plots.scalefontsizes() #hide
Plots.scalefontsizes(1.3) #hide

Plots.bar(cap_sum_plot.country, cap_sum_plot.capacity_mw_sum, legend=false)

savefig(joinpath(@OUTPUT, "D0-processing-g1.svg")); # hide

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

histogram(data_nmiss.plant_age, color="blue",  bins=100, label="Plant Age Frequency",
          normalize=:pdf, alpha=0.5, xlim=(0,130))
vline!([mean_age], linewidth=2, color="red", label="Mean Age")
vline!([median_age], linewidth=2, color="orange", label="Median Age")


savefig(joinpath(@OUTPUT, "D0-processing-g2.svg")); # hide

age = select(data_nmiss, [:country, :primary_fuel, :plant_age])
age_mean = combine(groupby(age, [:country, :primary_fuel]), :plant_age => mean)

coal_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Coal", age_mean.primary_fuel), :]
gas_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Gas", age_mean.primary_fuel), :]

p1 = Plots.bar(coal_means.country, coal_means.plant_age_mean, ylabel="Age", title="Coal")
p2 = Plots.bar(gas_means.country, gas_means.plant_age_mean, title="Gas")

plot(p1, p2, layout=(1, 2), size=(900,600), plot_title="Mean plant age by country and technology")


savefig(joinpath(@OUTPUT, "D0-processing-g3.svg")); # hide
