# This file was generated, do not modify it. # hide
coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !iszero(df.yr_renovated)
df.has_basement = @. !iszero(df.sqft_basement)
schema(df)