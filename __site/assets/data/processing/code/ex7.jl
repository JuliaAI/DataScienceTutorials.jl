# This file was generated, do not modify it. # hide
capacity = select(data, [:country, :primary_fuel, :capacity_mw]);
first(capacity, 5)