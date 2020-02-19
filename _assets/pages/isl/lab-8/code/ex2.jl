# This file was generated, do not modify it. # hide
High = ifelse.(carseats.Sales .<= 8, "No", "Yes") |> categorical;
carseats[!, :High] = High;