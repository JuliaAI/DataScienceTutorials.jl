# This file was generated, do not modify it. # hide
fi = rpt.evo_tree_classifier.feature_importances
feature_importance_table =
    (feature=Symbol.(first.(fi)), importance=last.(fi)) |> DataFrames.DataFrame