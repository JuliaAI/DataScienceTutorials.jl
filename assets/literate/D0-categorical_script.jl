# This file was generated, do not modify it.

using CategoricalArrays

v = categorical(["AA", "BB", "CC", "AA", "BB", "CC"])

levels(v)

v = categorical([1, 2, 3, 1, 2, 3, 1, 2, 3], ordered=true)

levels(v)

v[1] < v[2]

v = categorical(["high", "med", "low", "high", "med", "low"], ordered=true)

levels(v)

v[1] < v[2]

levels!(v, ["low", "med", "high"])

v[1] < v[2]

v = categorical(["AA", "BB", missing, "AA", "BB", "CC"]);

levels(v)

