┌──────────────────────────┬────────────────────────────┬──────────────────────────┐
│ names                    │ scitypes                   │ types                    │
├──────────────────────────┼────────────────────────────┼──────────────────────────┤
│ country                  │ Textual                    │ String3                  │
│ country_long             │ Textual                    │ String                   │
│ name                     │ Textual                    │ String                   │
│ gppd_idnr                │ Textual                    │ String15                 │
│ capacity_mw              │ Continuous                 │ Float64                  │
│ latitude                 │ Continuous                 │ Float64                  │
│ longitude                │ Continuous                 │ Float64                  │
│ primary_fuel             │ Textual                    │ String15                 │
│ other_fuel1              │ Union{Missing, Textual}    │ Union{Missing, String15} │
│ other_fuel2              │ Union{Missing, Textual}    │ Union{Missing, String7}  │
│ other_fuel3              │ Union{Missing, Textual}    │ Union{Missing, String7}  │
│ commissioning_year       │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ owner                    │ Union{Missing, Textual}    │ Union{Missing, String}   │
│ source                   │ Union{Missing, Textual}    │ Union{Missing, String}   │
│ url                      │ Union{Missing, Textual}    │ Union{Missing, String}   │
│ geolocation_source       │ Union{Missing, Textual}    │ Union{Missing, String}   │
│ wepp_id                  │ Union{Missing, Textual}    │ Union{Missing, String31} │
│ year_of_capacity_data    │ Union{Missing, Count}      │ Union{Missing, Int64}    │
│ generation_gwh_2013      │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ generation_gwh_2014      │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ generation_gwh_2015      │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ generation_gwh_2016      │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ generation_gwh_2017      │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
│ generation_data_source   │ Union{Missing, Textual}    │ Union{Missing, String}   │
│ estimated_generation_gwh │ Union{Missing, Continuous} │ Union{Missing, Float64}  │
└──────────────────────────┴────────────────────────────┴──────────────────────────┘
