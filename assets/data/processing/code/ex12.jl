# This file was generated, do not modify it. # hide
sort!(cap_sum_plot, :capacity_mw_sum, rev=true)

figure(figsize=(8,6))

plt.bar(cap_sum_plot.country, cap_sum_plot.capacity_mw_sum, width=0.35)
plt.xticks(rotation=90)

savefig(joinpath(@OUTPUT, "D0-processing-g1.svg")) # hide