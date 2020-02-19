# This file was generated, do not modify it. # hide
xgb = fitted_params(mtm).best_model
@show xgb.subsample
@show xgb.colsample_bytree