┌───────────────────────┬─────────────────────────┬────────────────────────────┐
│ _.names               │ _.types                 │ _.scitypes                 │
├───────────────────────┼─────────────────────────┼────────────────────────────┤
│ country               │ String                  │ Textual                    │
│ country_long          │ String                  │ Textual                    │
│ name                  │ String                  │ Textual                    │
│ gppd_idnr             │ String                  │ Textual                    │
│ capacity_mw           │ Float64                 │ Continuous                 │
│ latitude              │ Float64                 │ Continuous                 │
│ longitude             │ Float64                 │ Continuous                 │
│ primary_fuel          │ String                  │ Textual                    │
│ other_fuel1           │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ other_fuel2           │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ other_fuel3           │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ commissioning_year    │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ year_of_capacity_data │ Union{Missing, Int64}   │ Union{Missing, Count}      │
└───────────────────────┴─────────────────────────┴────────────────────────────┘
_.nrows = 33643
