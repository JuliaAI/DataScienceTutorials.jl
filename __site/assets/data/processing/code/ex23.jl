# This file was generated, do not modify it. # hide
p1 = Plots.bar(coal_means.country, coal_means.plant_age_mean, ylabel="Age", title="Coal")
p2 = Plots.bar(gas_means.country, gas_means.plant_age_mean, title="Gas")

plot(p1, p2, layout=(1, 2), size=(900,600), plot_title="Mean plant age by country and technology")


savefig(joinpath(@OUTPUT, "D0-processing-g3.svg")); # hide