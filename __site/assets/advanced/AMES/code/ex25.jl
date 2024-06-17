# This file was generated, do not modify it. # hide
blended_best = fitted_params(mach).best_model
@show blended_best.knn_model.K
@show blended_best.ridge_model.lambda
@show blended_best.knn_weight