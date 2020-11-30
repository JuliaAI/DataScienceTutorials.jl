13×8 DataFrame
│ Row │ variable              │ mean    │ min         │ median  │ max               │ nunique │ nmissing │ eltype                  │
│     │ Symbol                │ Union…  │ Any         │ Union…  │ Any               │ Union…  │ Union…   │ Type                    │
├─────┼───────────────────────┼─────────┼─────────────┼─────────┼───────────────────┼─────────┼──────────┼─────────────────────────┤
│ 1   │ country               │         │ AFG         │         │ ZWE               │ 167     │          │ String                  │
│ 2   │ country_long          │         │ Afghanistan │         │ Zimbabwe          │ 167     │          │ String                  │
│ 3   │ name                  │         │ 'Muela      │         │ \u200bVärtaverket │ 33232   │          │ String                  │
│ 4   │ gppd_idnr             │         │ ARG0000001  │         │ WRI1075863        │ 33643   │          │ String                  │
│ 5   │ capacity_mw           │ 168.993 │ 1.0         │ 18.3    │ 22500.0           │         │          │ Float64                 │
│ 6   │ latitude              │ 32.5014 │ -77.847     │ 39.5835 │ 71.292            │         │          │ Float64                 │
│ 7   │ longitude             │ -4.1955 │ -179.978    │ -1.2744 │ 179.389           │         │          │ Float64                 │
│ 8   │ primary_fuel          │         │ Biomass     │         │ Wind              │ 15      │          │ String                  │
│ 9   │ other_fuel1           │         │ Biomass     │         │ Wind              │ 12      │ 31680    │ Union{Missing, String}  │
│ 10  │ other_fuel2           │         │ Biomass     │         │ Wind              │ 11      │ 33340    │ Union{Missing, String}  │
│ 11  │ other_fuel3           │         │ Biomass     │         │ Wind              │ 7       │ 33539    │ Union{Missing, String}  │
│ 12  │ commissioning_year    │ 1995.49 │ 1896.0      │ 2005.0  │ 2018.0            │         │ 17340    │ Union{Missing, Float64} │
│ 13  │ year_of_capacity_data │ 2016.86 │ 2000        │ 2017.0  │ 2018              │         │ 19900    │ Union{Missing, Int64}   │