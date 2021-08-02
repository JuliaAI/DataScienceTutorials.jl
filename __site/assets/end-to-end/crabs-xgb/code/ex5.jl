# This file was generated, do not modify it. # hide
train, test = partition(eachindex(y), 0.70, shuffle=true, rng=52)
XGBC = @load XGBoostClassifier
xgb_model = XGBC()