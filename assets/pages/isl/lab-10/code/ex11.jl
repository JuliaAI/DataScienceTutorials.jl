# This file was generated, do not modify it. # hide
Random.seed!(1515)

@load KMeans
@pipeline SPCA2(std = Standardizer(),
                pca = PCA(),
                km = KMeans(k=3))

spca2_mdl = SPCA2()
spca2 = machine(spca2_mdl, X)
fit!(spca2)

assignments = report(spca2).reports[1].assignments
mask1 = assignments .== 1
mask2 = assignments .== 2
mask3 = assignments .== 3;