# This file was generated, do not modify it. # hide
gdf = groupby(iris, :Species)
combine(gdf, :PetalLength => mean => :MPL, :PetalLength => std => :SPL)