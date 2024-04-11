# This file was generated, do not modify it. # hide
missing_outcome = ismissing.(data.outcome)
idx_missing_outcome = missing_outcome |> findall