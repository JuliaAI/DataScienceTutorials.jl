# This file was generated, do not modify it. # hide
train, test = partition(eachindex(y_wind), 0.7, shuffle=true, rng=5);