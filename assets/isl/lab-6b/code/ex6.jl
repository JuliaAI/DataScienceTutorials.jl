# This file was generated, do not modify it. # hide
# And keep only the corresponding features values.

y = collect(skipmissing(y))
X = X[no_miss, :];

# Let's now split our dataset into a train and test sets.
train, test = partition(eachindex(y), 0.5, shuffle = true, rng = 424);