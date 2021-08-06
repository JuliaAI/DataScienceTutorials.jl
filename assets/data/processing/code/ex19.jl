# This file was generated, do not modify it. # hide
map!(x -> round(x, digits=0), data_nmiss.commissioning_year, data_nmiss.commissioning_year);

# We can now calculate plant age for each plant (worth remembering that the dataset only contains active plants)

current_year = fill!(Array{Float64}(undef, size(data_nmiss)[1]), 2020);
data_nmiss[:, :plant_age] = current_year - data_nmiss[:, :commissioning_year];