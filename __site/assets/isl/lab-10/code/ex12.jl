# This file was generated, do not modify it. # hide
Random.seed!(1515)

KMeans = @load KMeans pkg=Clustering
SPCA2 = @pipeline(Standardizer(),
                  PCA(),
                  KMeans(k=3))

spca2 = machine(SPCA2, X)
fit!(spca2)

assignments = collect(values(report(spca2).report_given_machine))[3].assignments
mask1 = assignments .== 1
mask2 = assignments .== 2
mask3 = assignments .== 3;