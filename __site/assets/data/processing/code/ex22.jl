# This file was generated, do not modify it. # hide
age = select(data_nmiss, [:country, :primary_fuel, :plant_age])
age_mean = combine(groupby(age, [:country, :primary_fuel]), :plant_age => mean)

coal_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Coal", age_mean.primary_fuel), :]
gas_means = age_mean[occursin.(ctry_selec, age_mean.country) .& occursin.(r"Gas", age_mean.primary_fuel), :]