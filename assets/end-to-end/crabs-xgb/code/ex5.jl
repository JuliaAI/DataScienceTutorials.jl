# This file was generated, do not modify it. # hide
train, test = partition(collect(eachindex(y)), 0.70, rng=StableRNG(123))
XGBC = @load XGBoostClassifier
xgb_model = XGBC()