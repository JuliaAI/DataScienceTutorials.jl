# This file was generated, do not modify it. # hide
train = 1:findlast(X.Year .< 2005)
test = last(train)+1:length(y);