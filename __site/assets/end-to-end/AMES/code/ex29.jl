# This file was generated, do not modify it. # hide
krb_best = fitted_params(mtm).best_model
@show krb_best.knn_model.K
@show krb_best.ridge_model.lambda
@show krb_best.knn_weight