# This file was generated, do not modify it. # hide
rng = StableRNG(123)
Xcont = (x1 = rand(rng, 5), x2 = rand(5))
mach = machine(transformed_target_model, Xcont, y) |> fit!
yhat = predict(mach, Xcont)