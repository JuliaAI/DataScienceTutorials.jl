# This file was generated, do not modify it. # hide
gdf = groupby(iris, :Species)
combine(gdf, MPL=:PetalLength=>mean, SPL=:PetalLength=>std)