# This file was generated, do not modify it. # hide
cap_mean = combine(cap_gr, :capacity_mw => mean)
cap_sum = combine(cap_gr, :capacity_mw => sum)
first(cap_sum, 3)