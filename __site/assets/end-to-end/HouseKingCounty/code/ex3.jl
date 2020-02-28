# This file was generated, do not modify it. # hide
coerce!(df, :zipcode => Multiclass)
df.isrenovated  = @. !ismissing(df.yr_renovated)
df.has_basement = @. !ismissing(df.sqft_basement)
schema(df)