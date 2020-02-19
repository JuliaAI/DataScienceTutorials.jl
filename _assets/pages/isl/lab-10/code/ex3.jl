# This file was generated, do not modify it. # hide
X = select(data, Not(:State))
X = coerce(X, :UrbanPop=>Continuous);