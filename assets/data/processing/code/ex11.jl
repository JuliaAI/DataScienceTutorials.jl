# This file was generated, do not modify it. # hide
ctry_selec = r"BEL|FRA|DEU"
tech_selec = r"Solar"

cap_sum_plot = cap_sum[occursin.(ctry_selec, cap_sum.country) .& occursin.(tech_selec, cap_sum.primary_fuel), :]