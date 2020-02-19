# This file was generated, do not modify it. # hide
k_range = range(krb, :(knn_model.K), lower=2, upper=100, scale=:log10)
l_range = range(krb, :(ridge_model.lambda), lower=1e-4, upper=10, scale=:log10)
w_range = range(krb, :(knn_weight), lower=0.1, upper=0.9)

ranges = [k_range, l_range, w_range]