# This file was generated, do not modify it. # hide
cap_sum = DataFrame(cap_sum);
cap_sum_ctry = DataFrame(cap_sum_ctry);
cap_share = leftjoin(cap_sum, cap_sum_ctry, on = :country, makeunique = true)
cap_share.capacity_mw_share = cap_share.capacity_mw_sum ./ cap_share.capacity_mw_sum_1;