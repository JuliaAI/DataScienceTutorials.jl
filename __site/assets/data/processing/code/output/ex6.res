┌───────────────────────┬────────────────────────────┬──────────────────────────┐
│ names                 │ scitypes                   │ types                    │
├───────────────────────┼────────────────────────────┼──────────────────────────┤
│ country               │ Textual                    │ String3                  │
│ country_long          │ Textual                    │ String63                 │
│ name                  │ Textual                    │ String                   │
│ gppd_idnr             │ Textual                    │ String15                 │
│ capacity_mw           │ Continuous                 │ Float64                  │
│ latitude              │ Continuous                 │ Float64                  │
│ longitude             │ Continuous                 │ Float64                  │
│ primary_fuel          │ Textual                    │ String15                 │
│ other_fuel1           │ Union{Missing, Textual}    │ Union{Missing, String15} │
│ other_fuel2           │ Union{Missing, Textual}    │ Union{Missing, String7}  │
│ other_fuel3           │ Union{Missing, Textual}    │ Union{Missing, String7}  │
│ commissioning_year    │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ year_of_capacity_data │ Union{Missing, Count}      │ Union{Missing, Int64}    │
└───────────────────────┴────────────────────────────┴──────────────────────────┘
