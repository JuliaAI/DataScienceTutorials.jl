# This file was generated, do not modify it. # hide
pipe = (X -> coerce(X, :age=>Continuous)) |> OneHotEncoder() |> transformed_target_model