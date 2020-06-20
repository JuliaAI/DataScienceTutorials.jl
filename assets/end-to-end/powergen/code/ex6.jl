# This file was generated, do not modify it. # hide
colnames = names(weather)

filter_by_name(name, cols) =
    filter(cn -> occursin(name, String(cn)), cols)

wind   = weather[:, filter_by_name("windspeed", colnames)]
temp   = weather[:, filter_by_name("temperature", colnames)]
raddir = weather[:, filter_by_name("radiation_direct", colnames)]
raddif = weather[:, filter_by_name("radiation_diffuse", colnames)];