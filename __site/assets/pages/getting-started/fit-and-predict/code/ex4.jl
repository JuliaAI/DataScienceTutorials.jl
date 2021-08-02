# This file was generated, do not modify it. # hide
train, test = partition(eachindex(y), 0.7, shuffle=true)
test[1:3]