# This file was generated, do not modify it. # hide
is_active(col) = !occursin(r"source|generation", string(col))
active_cols = [col for col in names(data) if is_active(col)]
select!(data, active_cols);