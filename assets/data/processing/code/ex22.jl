# This file was generated, do not modify it. # hide
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

savefig(joinpath(@OUTPUT, "D0-processing-g3.svg")) # hide