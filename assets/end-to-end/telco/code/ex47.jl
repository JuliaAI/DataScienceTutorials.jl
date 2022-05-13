# This file was generated, do not modify it. # hide
unimportant_features = filter(:importance => <(0.005), feature_importance_table).feature

pipe2 = ContinuousEncoder() |>
    FeatureSelector(features=unimportant_features, ignore=true) |> booster