# This file was generated, do not modify it. # hide
df.waterfront = (df.waterfront .!= "FALSE")
coerce!(df, :waterfront => OrderedFactor);