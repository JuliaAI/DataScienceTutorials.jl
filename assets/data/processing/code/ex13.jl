# This file was generated, do not modify it. # hide
cap_sum_ctry_gd = groupby(capacity, [:country]);
cap_sum_ctry = combine(cap_sum_ctry_gd, :capacity_mw => sum);