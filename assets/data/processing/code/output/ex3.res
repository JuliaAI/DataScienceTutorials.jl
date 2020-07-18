┌──────────────────────────┬─────────────────────────┬────────────────────────────┐
│ _.names                  │ _.types                 │ _.scitypes                 │
├──────────────────────────┼─────────────────────────┼────────────────────────────┤
│ country                  │ String                  │ Textual                    │
│ country_long             │ String                  │ Textual                    │
│ name                     │ String                  │ Textual                    │
│ gppd_idnr                │ String                  │ Textual                    │
│ capacity_mw              │ Float64                 │ Continuous                 │
│ latitude                 │ Float64                 │ Continuous                 │
│ longitude                │ Float64                 │ Continuous                 │
│ primary_fuel             │ String                  │ Textual                    │
│ other_fuel1              │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ other_fuel2              │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ other_fuel3              │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ commissioning_year       │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ owner                    │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ source                   │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ url                      │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ geolocation_source       │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ wepp_id                  │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ year_of_capacity_data    │ Union{Missing, Int64}   │ Union{Missing, Count}      │
│ generation_gwh_2013      │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ generation_gwh_2014      │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ generation_gwh_2015      │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ generation_gwh_2016      │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ generation_gwh_2017      │ Union{Missing, Float64} │ Union{Missing, Continuous} │
│ generation_data_source   │ Union{Missing, String}  │ Union{Missing, Textual}    │
│ estimated_generation_gwh │ Union{Missing, Float64} │ Union{Missing, Continuous} │
└──────────────────────────┴─────────────────────────┴────────────────────────────┘
_.nrows = 33643
