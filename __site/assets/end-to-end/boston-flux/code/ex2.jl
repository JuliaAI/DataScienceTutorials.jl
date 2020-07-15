# This file was generated, do not modify it. # hide
features, targets = MLJ.@load_boston
features = DataFrames.DataFrame(features)
@show size(features)
@show targets[1:3]
first(features, 3) |> MLJ.pretty